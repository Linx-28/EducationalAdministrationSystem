package com.example.eduadmin.util;

public class GradeCalculator {
    
    public static Double calculateFinalScore(Double regularScore, Double examScore) {
        if (regularScore == null) regularScore = 0.0;
        if (examScore == null) examScore = 0.0;
        return regularScore * 0.3 + examScore * 0.7;
    }
    
    public static Double calculateGpa(Double finalScore) {
        if (finalScore == null) return 0.0;
        if (finalScore >= 90) return 4.0;
        if (finalScore >= 85) return 3.7;
        if (finalScore >= 82) return 3.3;
        if (finalScore >= 78) return 3.0;
        if (finalScore >= 75) return 2.7;
        if (finalScore >= 72) return 2.3;
        if (finalScore >= 68) return 2.0;
        if (finalScore >= 64) return 1.5;
        if (finalScore >= 60) return 1.0;
        return 0.0;
    }
    
    public static Double calculateGpa(Double[] finalScores, Double[] credits) {
        if (finalScores == null || credits == null || finalScores.length != credits.length) {
            return 0.0;
        }
        double totalCredits = 0;
        double totalPoints = 0;
        for (int i = 0; i < finalScores.length; i++) {
            totalCredits += credits[i];
            totalPoints += calculateGpa(finalScores[i]) * credits[i];
        }
        return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
    }
}