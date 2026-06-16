package com.example.eduadmin.model.entity;

import java.io.Serializable;

public class Admin extends User implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String name;
    
    public Admin() {}
    
    public Admin(Integer userId, String username, String password, String name) {
        super(userId, username, password, "admin");
        this.name = name;
    }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}