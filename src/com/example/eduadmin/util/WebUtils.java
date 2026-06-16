package com.example.eduadmin.util;

import com.google.gson.Gson;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Field;
import java.util.Map;

public class WebUtils {

    public static String getParameter(javax.servlet.http.HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        return value != null && !value.isEmpty() ? value : defaultValue;
    }

    public static Integer getParameterInt(javax.servlet.http.HttpServletRequest request, String name, Integer defaultValue) {
        String value = request.getParameter(name);
        if (value != null && !value.isEmpty()) {
            try { return Integer.parseInt(value); } catch (NumberFormatException e) {}
        }
        return defaultValue;
    }

    public static void writeJson(HttpServletResponse response, Object obj) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        out.print(gson.toJson(obj));
        out.flush();
    }

    @SuppressWarnings("unchecked")
    public static <T> T copyParamToBean(Map<String, String[]> map, T bean) {
        try {
            for (Map.Entry<String, String[]> entry : map.entrySet()) {
                String name = entry.getKey();
                String[] values = entry.getValue();
                if (values != null && values.length > 0) {
                    try {
                        Field field = bean.getClass().getDeclaredField(name);
                        field.setAccessible(true);
                        Object value = values[0];
                        if (field.getType() == Integer.class || field.getType() == int.class) {
                            value = Integer.parseInt(values[0]);
                        } else if (field.getType() == Double.class || field.getType() == double.class) {
                            value = Double.parseDouble(values[0]);
                        } else if (field.getType() == Float.class || field.getType() == float.class) {
                            value = Float.parseFloat(values[0]);
                        } else if (field.getType() == Boolean.class || field.getType() == boolean.class) {
                            value = Boolean.parseBoolean(values[0]);
                        }
                        field.set(bean, value);
                    } catch (NoSuchFieldException e) {
                        // skip fields not in this class
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bean;
    }
}