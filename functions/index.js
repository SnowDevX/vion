const { onCall } = require("firebase-functions/v2/https");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

// ============================================
// دالة مزامنة الخطوات (يستدعيها التطبيق)
// ============================================
exports.syncSteps = onCall(async (request) => {
    if (!request.auth) {
        return { error: "يجب تسجيل الدخول" };
    }

    const userId = request.auth.uid;
    const { steps } = request.data;

    if (!steps || typeof steps !== "number") {
        return { error: "عدد الخطوات مطلوب" };
    }

    try {
        const today = new Date().toISOString().split('T')[0];
        const dailyStepsRef = db.collection("dailySteps").doc(`${userId}_${today}`);

        await dailyStepsRef.set({
            userId,
            date: today,
            steps,
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        }, { merge: true });

        const pointsEarned = Math.floor(steps / 100);

        return {
            success: true,
            steps,
            points: pointsEarned
        };
    } catch (error) {
        return { error: "حدث خطأ في الخادم" };
    }
});

// ============================================
// دالة جلب إحصائيات المستخدم
// ============================================
exports.getUserStats = onCall(async (request) => {
    if (!request.auth) {
        return { error: "يجب تسجيل الدخول" };
    }

    const userId = request.auth.uid;

    try {
        const userDoc = await db.collection("users").doc(userId).get();

        if (!userDoc.exists) {
            return {
                totalSteps: 0,
                totalPoints: 0,
                dailyGoal: 10000,
                todayProgress: 0
            };
        }

        const userData = userDoc.data();

        const today = new Date().toISOString().split('T')[0];
        const todayDoc = await db.collection("dailySteps").doc(`${userId}_${today}`).get();
        const todaySteps = todayDoc.exists ? todayDoc.data().steps || 0 : 0;

        return {
            totalSteps: userData.totalSteps || 0,
            totalPoints: userData.totalPoints || 0,
            dailyGoal: userData.dailyGoal || 10000,
            todayProgress: Math.round((todaySteps / (userData.dailyGoal || 10000)) * 100)
        };
    } catch (error) {
        return { error: "حدث خطأ" };
    }
});

// ============================================
// تحديث تلقائي عند إضافة خطوات
// ============================================
exports.onStepsAdded = onDocumentWritten("dailySteps/{docId}", async (event) => {
    const data = event.data.after?.data();

    if (!data) return;

    const userId = data.userId;
    const steps = data.steps;
    const pointsEarned = Math.floor(steps / 100);

    try {
        const userRef = db.collection("users").doc(userId);

        await db.runTransaction(async (transaction) => {
            const userDoc = await transaction.get(userRef);

            if (!userDoc.exists) {
                transaction.set(userRef, {
                    totalSteps: steps,
                    totalPoints: pointsEarned,
                    lastUpdated: admin.firestore.FieldValue.serverTimestamp()
                });
            } else {
                const currentTotalSteps = userDoc.data().totalSteps || 0;
                const currentTotalPoints = userDoc.data().totalPoints || 0;

                transaction.update(userRef, {
                    totalSteps: currentTotalSteps + steps,
                    totalPoints: currentTotalPoints + pointsEarned,
                    lastUpdated: admin.firestore.FieldValue.serverTimestamp()
                });
            }
        });

        await db.collection("pointsTransactions").add({
            userId,
            points: pointsEarned,
            type: "earned",
            description: `مقابل ${steps} خطوة`,
            createdAt: admin.firestore.FieldValue.serverTimestamp()
        });

    } catch (error) {
        console.error("خطأ:", error);
    }
});