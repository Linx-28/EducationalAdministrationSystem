package com.example.eduadmin.controller;

import com.example.eduadmin.model.entity.CourseSchedule;
import com.example.eduadmin.model.entity.Score;
import com.example.eduadmin.model.service.ScheduleService;
import com.example.eduadmin.model.service.ScoreService;
import com.example.eduadmin.model.service.impl.ScheduleServiceImpl;
import com.example.eduadmin.model.service.impl.ScoreServiceImpl;
import com.example.eduadmin.util.WebUtils;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/score")
public class ScoreController extends BaseServlet {
    private ScoreService scoreService = new ScoreServiceImpl();
    private ScheduleService scheduleService = new ScheduleServiceImpl();

    protected void batchSave(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String scoresJson = req.getParameter("scores");
        if (scoresJson == null || scoresJson.isEmpty()) {
            resp.getWriter().print("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }
        try {
            Gson gson = new Gson();
            Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
            List<Map<String, String>> scoreList = gson.fromJson(scoresJson, listType);
            int count = 0;
            for (Map<String, String> item : scoreList) {
                Score score = new Score();
                score.setStudentId(Integer.parseInt(item.get("studentId")));
                String idStr = item.get("scheduleId");
                int id = Integer.parseInt(idStr);
                CourseSchedule cs = scheduleService.findById(id);
                if (cs != null) {
                    score.setScheduleId(id);
                } else {
                    List<CourseSchedule> courseSchedules = scheduleService.findBySemester("2025-2026-1");
                    for (CourseSchedule css : courseSchedules) {
                        if (css.getCourseId().intValue() == id) {
                            score.setScheduleId(css.getScheduleId());
                            break;
                        }
                    }
                }
                if (score.getScheduleId() == null) continue;
                String regular = item.get("regularScore");
                String exam = item.get("examScore");
                if (regular != null && !regular.isEmpty()) {
                    score.setRegularScore(Double.parseDouble(regular));
                }
                if (exam != null && !exam.isEmpty()) {
                    score.setExamScore(Double.parseDouble(exam));
                }
                if (scoreService.saveOrUpdate(score)) {
                    count++;
                }
            }
            Map<String, Object> json = new HashMap<>();
            json.put("success", true);
            json.put("message", "成功保存 " + count + " 条成绩");
            WebUtils.writeJson(resp, json);
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().print("{\"success\":false,\"message\":\"保存失败\"}");
        }
    }
}