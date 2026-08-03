/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore Studio
 * Music Composition & Notation
 *
 * Copyright (C) 2026 MuseScore Limited and others
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include "polylinepointstyle.h"

using namespace muse::uicomponents;

PolylinePointStyle::PolylinePointStyle(QObject* parent)
    : QObject(parent)
{
}

qreal PolylinePointStyle::centerRadius() const
{
    return m_centerRadius;
}

void PolylinePointStyle::setCenterRadius(qreal r)
{
    if (m_centerRadius == r) {
        return;
    }

    m_centerRadius = r;
    emit styleChanged();
}

QColor PolylinePointStyle::centerColor() const
{
    return m_centerColor;
}

void PolylinePointStyle::setCenterColor(const QColor& c)
{
    if (m_centerColor == c) {
        return;
    }

    m_centerColor = c;
    emit styleChanged();
}

qreal PolylinePointStyle::middleRingWidth() const
{
    return m_middleRingWidth;
}

void PolylinePointStyle::setMiddleRingWidth(qreal r)
{
    if (m_middleRingWidth == r) {
        return;
    }

    m_middleRingWidth = r;
    emit styleChanged();
}

QColor PolylinePointStyle::middleRingColor() const
{
    return m_middleRingColor;
}

void PolylinePointStyle::setMiddleRingColor(const QColor& c)
{
    if (m_middleRingColor == c) {
        return;
    }

    m_middleRingColor = c;
    emit styleChanged();
}

qreal PolylinePointStyle::outlineWidth() const
{
    return m_outlineWidth;
}

void PolylinePointStyle::setOutlineWidth(qreal w)
{
    if (m_outlineWidth == w) {
        return;
    }

    m_outlineWidth = w;
    emit styleChanged();
}

QColor PolylinePointStyle::outlineColor() const
{
    return m_outlineColor;
}

void PolylinePointStyle::setOutlineColor(const QColor& c)
{
    if (m_outlineColor == c) {
        return;
    }

    m_outlineColor = c;
    emit styleChanged();
}
