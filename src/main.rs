extern crate piston;
extern crate graphics;
extern crate glutin_window;
extern crate opengl_graphics;

use piston::window::WindowSettings;
use piston::window::Window;
use piston::event::*;
use piston::input::*;
use glutin_window::GlutinWindow;
use opengl_graphics::{ GlGraphics, OpenGL };

pub struct App {
    gl: GlGraphics, // OpenGL drawing backend.
    rotation: f64,   // Rotation for the square.

    box_x: f64,
    box_y: f64,
}

impl App {
    fn render(&mut self, args: &RenderArgs) {
        use graphics::*;

        const GREEN: [f32; 4] = [0.0, 1.0, 0.0, 1.0];
        const RED:   [f32; 4] = [1.0, 0.0, 0.0, 1.0];

        let square = rectangle::square(0.0, 0.0, 50.0);
        let rotation = self.rotation;
        let (x, y) = (self.box_x, self.box_y);

        self.gl.draw(args.viewport(), |c, gl| {
            // Clear the screen.
            clear(GREEN, gl);

            let transform = c.transform.trans(x, y)
                                       .rot_rad(rotation)
                                       .trans(-25.0, -25.0);

            // Draw a box rotating around the middle of the screen.
            rectangle(RED, square, transform, gl);
        });
    }

    fn update(&mut self, args: &UpdateArgs) {
        // Rotate 2 radians per second.
        self.rotation += 2.0 * args.dt;
    }

    fn keypress(&mut self, key: keyboard::Key) {
        use piston::input::keyboard::Key::*;

        match key {
            Up    => { self.box_y -= 10.0; },
            Down  => { self.box_y += 10.0; },
            Left  => { self.box_x -= 10.0; },
            Right => { self.box_x += 10.0; },
            _     => println!("other"),
        }
    }
}

fn main() {
    let opengl = OpenGL::_3_2;

    // Create an Glutin window.
    let window = GlutinWindow::new(
        opengl,
        WindowSettings::new(
            "romulus",
            [640, 480]
        )
        .exit_on_esc(true)
    );

    //println!("window size: {}x{}", window.size().width, window.size().height);

    // Create a new game and run it.
    let mut app = App {
        gl: GlGraphics::new(opengl),
        rotation: 0.0,
        box_x: (window.size().width / 2) as f64,
        box_y: (window.size().height / 2) as f64,
    };

    for e in window.events() {
        if let Some(r) = e.render_args() {
            app.render(&r);
        }

        if let Some(u) = e.update_args() {
            app.update(&u);
        }

        if let Some(b) = e.press_args() {
            match b {
                Button::Keyboard(key) => app.keypress(key),
                Button::Mouse(button) => println!("mouse button press"),
            }
        }
    }
}
