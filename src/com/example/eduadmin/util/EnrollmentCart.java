package com.example.eduadmin.util;

import com.example.eduadmin.model.entity.CourseSchedule;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentCart {
    private static final String CART_KEY = "enrollment_cart";
    
    public static List<CourseSchedule> getCart(HttpSession session) {
        List<CourseSchedule> cart = (List<CourseSchedule>) session.getAttribute(CART_KEY);
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute(CART_KEY, cart);
        }
        return cart;
    }
    
    public static boolean addToCart(HttpSession session, CourseSchedule schedule) {
        List<CourseSchedule> cart = getCart(session);
        for (CourseSchedule s : cart) {
            if (s.getScheduleId().equals(schedule.getScheduleId())) {
                return false; // 已存在
            }
        }
        cart.add(schedule);
        return true;
    }
    
    public static void removeFromCart(HttpSession session, Integer scheduleId) {
        List<CourseSchedule> cart = getCart(session);
        cart.removeIf(s -> s.getScheduleId().equals(scheduleId));
    }
    
    public static void clearCart(HttpSession session) {
        session.removeAttribute(CART_KEY);
    }
}