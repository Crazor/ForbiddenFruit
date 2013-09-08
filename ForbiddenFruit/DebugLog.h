/*
 * This file is part of ForbiddenFruit.
 *
 * Copyright 2013 Crazor <crazor@gmail.com>
 *
 * ForbiddenFruit is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * ForbiddenFruit is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with ForbiddenFruit.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef ForbiddenFruit_DebugLog_h
#define ForbiddenFruit_DebugLog_h

#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#define log(msg, ...) NSLog((@"%s:%d " msg), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#pragma clang diagnostic pop
#else
#define log(msg, ...)
#endif

#endif
