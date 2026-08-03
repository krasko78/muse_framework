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

#pragma once

#include <QObject>
#include <QColor>

namespace muse::uicomponents {
class PolylinePointStyle : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qreal centerRadius READ centerRadius WRITE setCenterRadius NOTIFY styleChanged)
    Q_PROPERTY(QColor centerColor READ centerColor WRITE setCenterColor NOTIFY styleChanged)

    Q_PROPERTY(qreal middleRingWidth READ middleRingWidth WRITE setMiddleRingWidth NOTIFY styleChanged)
    Q_PROPERTY(QColor middleRingColor READ middleRingColor WRITE setMiddleRingColor NOTIFY styleChanged)

    Q_PROPERTY(qreal outlineWidth READ outlineWidth WRITE setOutlineWidth NOTIFY styleChanged)
    Q_PROPERTY(QColor outlineColor READ outlineColor WRITE setOutlineColor NOTIFY styleChanged)

public:
    explicit PolylinePointStyle(QObject* parent = nullptr);

    qreal centerRadius() const;
    void setCenterRadius(qreal);

    QColor centerColor() const;
    void setCenterColor(const QColor&);

    qreal middleRingWidth() const;
    void setMiddleRingWidth(qreal);

    QColor middleRingColor() const;
    void setMiddleRingColor(const QColor&);

    qreal outlineWidth() const;
    void setOutlineWidth(qreal);

    QColor outlineColor() const;
    void setOutlineColor(const QColor&);

signals:
    void styleChanged();

private:
    qreal m_centerRadius = 3.0;
    QColor m_centerColor;

    qreal m_middleRingWidth = 0.0;
    QColor m_middleRingColor;

    qreal m_outlineWidth = 0.0;
    QColor m_outlineColor;
};
}
