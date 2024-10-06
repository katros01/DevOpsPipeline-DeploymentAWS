package com.gtp2.DevOpsPipeline.DeploymentAWS.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String welcome() {
        return "Welcome, the server is up and running!";
    }

    @GetMapping("/hello")
    public String sayHello() {
        return "Hello from Katros!";
    }
}
