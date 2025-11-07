package com.pepe.ProySpring.Controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class UnicoController {
    @GetMapping
    public String unicoEndpoint(){
        return "Hola desde acá";
    }
}
