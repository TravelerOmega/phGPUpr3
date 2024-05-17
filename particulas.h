//  Created by Antonio J. Rueda on 21/3/2024.
//  Copyright © 2024 Antonio J. Rueda.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

#ifndef particulas_h
#define particulas_h

#include <glm/glm.hpp>
#include "glad/glad/glad.h"
#include "glfwindow/glfwwindow.h"
#include "config.h"
#include "kernel.h"

using namespace glm;

class ParticulasApp : public GLFWWindow {
    
    using Coord = vec2;
        
    /** Calcular frames por segundo */
    void mostrarFR();

    /** Liberar recursos asignados */
    void liberarRecursos();
        
    /** Variables visualización --------------------------- */
    
    /** Programa shader visualización */
    GLuint progVis;
    
    /** Parámetro del shader asociado a las coordenadas de la partícula */
    const GLuint attribVisCoord = 0;
    
    /** VAO & array de vértices para particulas */
    GLuint vaoVis, vboVisCoords;

    /** Otros atributos -------------------------------------- */
    
    unsigned numParticulas;

    
    
    // Array de coordenadas de las partículas
    Coord coords[1000];
    Coord coordsPrevias[1000];
    Coord coordsSiguientes[1000];

    Kernel kernel;

    /** Tiempo de simulación */
    float t;
    
    /** Variables auxilisares FPS */
    double tVisUltimoFR;
    int numVisFrames;
    
public:
    /** Constructor */
    ParticulasApp(unsigned numParticulas);
    
    /** Preparar escena */
    void prepararVisualizacion();

    /** Dibujar escena */
    void visualizar();
    
    /** Establecer estado inicial de las partículas */
    void prepararSimulacion();
    
    /** Recalcular nueva posición de partículas */
    void simular();

    /** Bucle de rendering y simulación */
    void ejecutar();
    
    ~ParticulasApp() {
        liberarRecursos();
    }
};

#endif
