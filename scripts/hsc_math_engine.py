#!/usr/bin/env python3
import random

def gen_derivative_value():
    """Evaluate f'(x0) for a cubic polynomial"""
    a = random.choice([1, 2])
    b = random.randint(-4, 4)
    c = random.randint(-6, 6)
    d = random.randint(-9, 9)
    x0 = random.randint(1, 3)
    
    # f'(x) = 3*a*x^2 + 2*b*x + c
    ans = 3 * a * (x0**2) + 2 * b * x0 + c
    
    sign_b = "+" if b >= 0 else "-"
    sign_c = "+" if c >= 0 else "-"
    sign_d = "+" if d >= 0 else "-"
    prob = (
        "Topic: Differentiation (Derivative Evaluation)\n"
        f"  Given the function: f(x) = {a}x³ {sign_b} {abs(b)}x² {sign_c} {abs(c)}x {sign_d} {abs(d)}\n"
        f"  Find the value of the derivative f'({x0}).\n"
        "  (Tip: Differentiate term by term, then substitute x)"
    )
    return prob, ans

def gen_tangent_slope():
    """Slope of tangent dy/dx for a quadratic curve"""
    a = random.randint(2, 4)
    b = random.randint(-6, 6)
    c = random.randint(-8, 8)
    x0 = random.randint(2, 4)
    
    # y = a*x^2 + b*x + c  => dy/dx = 2*a*x + b
    slope = 2 * a * x0 + b
    sign_b = "+" if b >= 0 else "-"
    sign_c = "+" if c >= 0 else "-"
    prob = (
        "Topic: Differentiation (Slope of Tangent)\n"
        f"  Find the slope of the tangent (dy/dx) to the curve:\n"
        f"  y = {a}x² {sign_b} {abs(b)}x {sign_c} {abs(c)}\n"
        f"  at the point where x = {x0}."
    )
    return prob, slope

def gen_stationary_point():
    """Find x where dy/dx = 0"""
    a = random.randint(1, 3)
    target_x = random.choice([-4, -3, -2, -1, 1, 2, 3, 4])
    # dy/dx = 2*a*x + b = 0 => b = -2*a*target_x
    b = -2 * a * target_x
    c = random.randint(-7, 7)
    
    sign_b = "+" if b >= 0 else "-"
    sign_c = "+" if c >= 0 else "-"
    prob = (
        "Topic: Differentiation (Stationary Point)\n"
        f"  For the curve: y = {a}x² {sign_b} {abs(b)}x {sign_c} {abs(c)}\n"
        "  Find the x-coordinate of the point where the derivative dy/dx = 0."
    )
    return prob, target_x

def gen_second_derivative():
    """Evaluate f''(x0) for a cubic"""
    a = random.randint(1, 3)
    b = random.randint(-5, 5)
    c = random.randint(-8, 8)
    x0 = random.randint(1, 4)
    
    # f'(x) = 3*a*x^2 + 2*b*x + c
    # f''(x) = 6*a*x + 2*b
    ans = 6 * a * x0 + 2 * b
    sign_b = "+" if b >= 0 else "-"
    sign_c = "+" if c >= 0 else "-"
    prob = (
        "Topic: Differentiation (Second Derivative)\n"
        f"  Given: y = {a}x³ {sign_b} {abs(b)}x² {sign_c} {abs(c)}x\n"
        f"  Calculate the second derivative (d²y/dx²) at x = {x0}."
    )
    return prob, ans

def gen_quadratic_roots():
    """Algebra: alpha^2 + beta^2"""
    p = random.randint(4, 7)
    q = random.randint(2, 5)
    ans = p**2 - 2 * q
    prob = (
        "Topic: Quadratic Equations (Roots)\n"
        f"  If α and β are the roots of: x² - {p}x + {q} = 0,\n"
        "  calculate the value of (α² + β²).\n"
        "  (Tip: α + β = p, αβ = q, and α² + β² = (α + β)² - 2αβ)"
    )
    return prob, ans

def gen_vector_dot():
    """Vector Dot Product"""
    u = [random.randint(-3, 4) for _ in range(3)]
    v = [random.randint(-3, 4) for _ in range(3)]
    ans = sum(u[i] * v[i] for i in range(3))
    
    def fmt_vec(vec):
        signs = ["" if vec[0] >= 0 else "-", "+" if vec[1] >= 0 else "-", "+" if vec[2] >= 0 else "-"]
        return f"{vec[0]}i {signs[1]} {abs(vec[1])}j {signs[2]} {abs(vec[2])}k"
        
    prob = (
        "Topic: Vectors (Scalar Product)\n"
        f"  Given vectors:\n"
        f"    u = {fmt_vec(u)}\n"
        f"    v = {fmt_vec(v)}\n"
        "  Calculate the dot product: u • v."
    )
    return prob, ans

def gen_2x2_determinant():
    """Matrix determinant"""
    a = random.randint(-4, 5)
    b = random.randint(-4, 5)
    c = random.randint(-4, 5)
    d = random.randint(-4, 5)
    ans = a * d - b * c
    prob = (
        "Topic: Matrices (Determinant)\n"
        "  Calculate the determinant |A| of the 2×2 matrix:\n"
        f"    | {a:2d}  {b:2d} |\n"
        f"    | {c:2d}  {d:2d} |\n"
        "  (Formula: ad - bc)"
    )
    return prob, ans

def get_hsc_problem():
    generators = [
        gen_derivative_value,
        gen_tangent_slope,
        gen_stationary_point,
        gen_second_derivative,
        gen_quadratic_roots,
        gen_vector_dot,
        gen_2x2_determinant
    ]
    fn = random.choice(generators)
    return fn()

if __name__ == "__main__":
    for _ in range(5):
        p, a = get_hsc_problem()
        print(p)
        print("Answer:", a, "\n")
