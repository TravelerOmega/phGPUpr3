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

#ifndef kernel_h
#define kernel_h

#pragma once

#include <stdio.h>
#include <vector>
#define GLM_FORCE_CUDA
#define CUDA_VERSION 124131
#include <glm/glm.hpp>

using namespace glm;
using Coords = vec2;

class Kernel {

public:
	void kernel();
	void CUDAliberar();
	void CUDASimular(Coords* coordsPrevias, Coords* coords, Coords* coordsSiguientes, int numParticulas, float pasoT);
};

#endif
