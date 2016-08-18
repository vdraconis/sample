/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package renderer;

import flash.geom.Matrix3D;
import flash.Vector;

class ProjectionMatrix extends Matrix3D
{
    static public var NEAR:Int = 0;
    static public var FAR:Int = 4000;
	static private var g2d_instance:ProjectionMatrix;

    private var g2d_vector:Vector<Float>;

    public function new(v:Vector<Float> = null) {
        super(v);
        g2d_vector = Vector.ofArray([2.0, 0.0, 0.0, 0.0,
                                     0.0, -2.0, 0.0, 0.0,
                                     0.0, 0.0, 1/(FAR-NEAR), -NEAR/(FAR-NEAR),
                                     -1.0, 1.0, 0, 1.0
                                    ]);
    }

    static public function getOrtho(p_width:Float, p_height:Float, p_transform:Matrix3D = null):ProjectionMatrix {
        if (g2d_instance == null) g2d_instance = new ProjectionMatrix();
        return g2d_instance.ortho(p_width, p_height, p_transform);
    }

    public function ortho(p_width:Float, p_height:Float, p_transform:Matrix3D = null):ProjectionMatrix {
        g2d_vector[0] = 2/p_width;
        g2d_vector[5] = -2/p_height;
        this.copyRawDataFrom(g2d_vector);

        if (p_transform != null) this.prepend(p_transform);

        return this;
    }

    public function perspective(p_width:Float, p_height:Float, zNear:Float, zFar:Float):ProjectionMatrix {
        this.copyRawDataFrom(Vector.ofArray([2/p_width, 0.0, 0.0, 0.0,
                                             0.0, -2/p_height, 0.0, 0.0,
                                             0, 0, zFar/(zFar-zNear), 1.0,
                                             0, 0, (zNear*zFar)/(zNear-zFar), 0
                                            ]));

        return this;
    }
}