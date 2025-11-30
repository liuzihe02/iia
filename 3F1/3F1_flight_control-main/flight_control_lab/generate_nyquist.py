"""
Generate Nyquist diagrams for 3F1 Flight Control Lab Report
"""
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch

# Set up matplotlib for publication quality
plt.rcParams.update({
    'font.size': 11,
    'axes.labelsize': 12,
    'axes.titlesize': 12,
    'legend.fontsize': 10,
    'figure.figsize': (6, 5),
    'figure.dpi': 150,
    'savefig.dpi': 150,
    'savefig.bbox': 'tight',
})


def nyquist_manual_control():
    """
    Nyquist diagram for Q1: Manual control system
    L(s) = K(s)G(s) = (8 * e^{-s}) / (s(s + 10))
    With k=0.8, D=1s, so open-loop gain is 8.
    """
    # Frequency range (avoiding omega=0 which is singular)
    omega = np.logspace(-2, 2, 1000)

    # L(jw) = 8 * e^{-jw} / (jw * (jw + 10))
    # Let s = jw
    s = 1j * omega

    # Plant: G(s) = 10 / (s(s+10))
    G = 10 / (s * (s + 10))

    # Controller: K(s) = 0.8 * e^{-sD} with D=1
    K = 0.8 * np.exp(-s * 1.0)

    # Open-loop: L = K * G
    L = K * G

    # Create figure
    fig, ax = plt.subplots(figsize=(6, 5))

    # Plot the Nyquist curve
    ax.plot(L.real, L.imag, 'b-', linewidth=1.5, label=r'$L(j\omega)$ for $\omega > 0$')
    ax.plot(L.real, -L.imag, 'b--', linewidth=1.0, alpha=0.5, label=r'$L(j\omega)$ for $\omega < 0$')

    # Add arrows to show direction
    # Find points along the curve to add arrows
    arrow_indices = [50, 200, 400]
    for idx in arrow_indices:
        if idx < len(omega) - 1:
            dx = L.real[idx+5] - L.real[idx]
            dy = L.imag[idx+5] - L.imag[idx]
            ax.annotate('', xy=(L.real[idx+5], L.imag[idx+5]),
                       xytext=(L.real[idx], L.imag[idx]),
                       arrowprops=dict(arrowstyle='->', color='blue', lw=1.5))

    # Mark the critical point -1
    ax.plot(-1, 0, 'ro', markersize=8, label=r'Critical point $-1$')

    # Mark origin
    ax.plot(0, 0, 'ko', markersize=5)

    # Add annotations for key frequencies
    # At omega = 0.8 rad/s (gain crossover)
    omega_gc = 0.8
    s_gc = 1j * omega_gc
    L_gc = 0.8 * np.exp(-s_gc) * 10 / (s_gc * (s_gc + 10))
    ax.plot(L_gc.real, L_gc.imag, 'g*', markersize=12, label=r'$\omega_{gc} = 0.8$ rad/s')
    ax.annotate(r'$\omega_{gc}$', xy=(L_gc.real, L_gc.imag),
               xytext=(L_gc.real - 0.3, L_gc.imag + 0.3),
               fontsize=10)

    # Annotate low and high frequency limits
    ax.annotate(r'$\omega \to 0$', xy=(L.real[5], L.imag[5]),
               xytext=(L.real[5] + 0.2, L.imag[5] - 0.5),
               fontsize=10, arrowprops=dict(arrowstyle='->', color='gray'))
    ax.annotate(r'$\omega \to \infty$', xy=(L.real[-1], L.imag[-1]),
               xytext=(0.3, 0.3),
               fontsize=10, arrowprops=dict(arrowstyle='->', color='gray'))

    # Set axis properties
    ax.axhline(y=0, color='k', linewidth=0.5)
    ax.axvline(x=0, color='k', linewidth=0.5)
    ax.set_xlabel('Real')
    ax.set_ylabel('Imaginary')
    ax.set_title(r'Nyquist Diagram: $L(s) = \frac{8e^{-s}}{s(s+10)}$')
    ax.set_xlim([-2.5, 1])
    ax.set_ylim([-3, 1])
    ax.grid(True, alpha=0.3)
    ax.set_aspect('equal')
    ax.legend(loc='lower left', fontsize=9)

    plt.tight_layout()
    plt.savefig('nyquist_q1.png', dpi=150, bbox_inches='tight')
    plt.show()
    print("Saved nyquist_q1.png")


def nyquist_unstable_aircraft():
    """
    Nyquist diagram for Q6: Unstable aircraft
    G2(s) = 2 / (sT - 1) with T = 0.6

    This is a circle! Let's derive it:
    G2(jw) = 2 / (jwT - 1) = 2 / (-(1 - jwT))
           = -2 / (1 - jwT)
           = -2(1 + jwT) / ((1 - jwT)(1 + jwT))
           = -2(1 + jwT) / (1 + w^2 T^2)

    Real part: -2 / (1 + w^2 T^2)
    Imag part: -2wT / (1 + w^2 T^2)

    As w: 0 -> inf, traces circle from -2 to 0 on real axis
    """
    T = 0.6  # From worksheet
    omega = np.linspace(0, 50, 500)

    # G2(jw) = 2 / (jwT - 1)
    s = 1j * omega
    G2 = 2 / (s * T - 1)

    # Also compute the parametric form to verify it's a circle
    # Real = -2 / (1 + w^2 T^2)
    # Imag = -2wT / (1 + w^2 T^2)
    denom = 1 + omega**2 * T**2
    real_part = -2 / denom
    imag_part = -2 * omega * T / denom

    fig, ax = plt.subplots(figsize=(6, 5))

    # Plot the Nyquist curve (omega > 0)
    ax.plot(G2.real, G2.imag, 'b-', linewidth=2, label=r'$G_2(j\omega)$ for $\omega > 0$')

    # Mirror for omega < 0
    ax.plot(G2.real, -G2.imag, 'b--', linewidth=1.5, alpha=0.7, label=r'$G_2(j\omega)$ for $\omega < 0$')

    # Draw the theoretical circle for reference (centered at -1, radius 1)
    theta = np.linspace(0, 2*np.pi, 100)
    circle_x = -1 + 1 * np.cos(theta)
    circle_y = 1 * np.sin(theta)
    ax.plot(circle_x, circle_y, 'g:', linewidth=1, alpha=0.5, label='Circle (center=-1, r=1)')

    # Add direction arrows
    arrow_indices = [20, 100, 200]
    for idx in arrow_indices:
        if idx < len(omega) - 5:
            ax.annotate('', xy=(G2.real[idx+5], G2.imag[idx+5]),
                       xytext=(G2.real[idx], G2.imag[idx]),
                       arrowprops=dict(arrowstyle='->', color='blue', lw=1.5))

    # Mark critical point -1
    ax.plot(-1, 0, 'ro', markersize=8, label=r'Critical point $-1$')

    # Mark -1/K for K = 0.5 (at -2, the boundary of stability)
    ax.plot(-2, 0, 'ms', markersize=8, label=r'$-1/K$ for $K=0.5$')

    # Mark key points
    ax.plot(-2, 0, 'k.', markersize=10)  # omega = 0
    ax.annotate(r'$\omega = 0$', xy=(-2, 0), xytext=(-2.3, 0.3), fontsize=10)
    ax.annotate(r'$\omega \to \infty$', xy=(0, 0), xytext=(0.2, 0.3), fontsize=10)

    # Mark origin
    ax.plot(0, 0, 'ko', markersize=5)

    ax.axhline(y=0, color='k', linewidth=0.5)
    ax.axvline(x=0, color='k', linewidth=0.5)
    ax.set_xlabel('Real')
    ax.set_ylabel('Imaginary')
    ax.set_title(r'Nyquist Diagram: $G_2(s) = \frac{2}{0.6s - 1}$ (Unstable Aircraft)')
    ax.set_xlim([-3, 1])
    ax.set_ylim([-2, 2])
    ax.grid(True, alpha=0.3)
    ax.set_aspect('equal')
    ax.legend(loc='lower right', fontsize=9)

    plt.tight_layout()
    plt.savefig('nyquist_q6.png', dpi=150, bbox_inches='tight')
    plt.show()
    print("Saved nyquist_q6.png")


def nyquist_unstable_with_delay():
    """
    Nyquist diagram for Q8: Unstable aircraft with time delay
    G2(s) * e^{-sD} = (2 / (sT - 1)) * e^{-sD}

    The delay adds phase -wD without changing magnitude.
    The circle becomes a spiral.
    """
    T = 0.6
    D = 0.3  # Small delay
    omega = np.linspace(0, 30, 500)

    s = 1j * omega

    # Without delay
    G2_no_delay = 2 / (s * T - 1)

    # With delay
    G2_with_delay = G2_no_delay * np.exp(-s * D)

    fig, ax = plt.subplots(figsize=(6, 5))

    # Plot without delay (dashed)
    ax.plot(G2_no_delay.real, G2_no_delay.imag, 'b--', linewidth=1.5,
            alpha=0.5, label=r'$G_2(j\omega)$ without delay')

    # Plot with delay (solid)
    ax.plot(G2_with_delay.real, G2_with_delay.imag, 'b-', linewidth=2,
            label=r'$G_2(j\omega)e^{-j\omega D}$ with $D=0.3$s')

    # Add direction arrows for the delayed curve
    arrow_indices = [30, 100, 200]
    for idx in arrow_indices:
        if idx < len(omega) - 5:
            ax.annotate('', xy=(G2_with_delay.real[idx+5], G2_with_delay.imag[idx+5]),
                       xytext=(G2_with_delay.real[idx], G2_with_delay.imag[idx]),
                       arrowprops=dict(arrowstyle='->', color='blue', lw=1.5))

    # Mark critical point -1
    ax.plot(-1, 0, 'ro', markersize=8, label=r'Critical point $-1$')

    # Mark key points
    ax.plot(-2, 0, 'ko', markersize=8)  # omega = 0 (same for both)
    ax.annotate(r'$\omega = 0$', xy=(-2, 0), xytext=(-2.3, 0.3), fontsize=10)

    ax.axhline(y=0, color='k', linewidth=0.5)
    ax.axvline(x=0, color='k', linewidth=0.5)
    ax.set_xlabel('Real')
    ax.set_ylabel('Imaginary')
    ax.set_title(r'Nyquist Diagram: $G_2(s)e^{-sD}$ (with time delay)')
    ax.set_xlim([-3, 1])
    ax.set_ylim([-2, 2])
    ax.grid(True, alpha=0.3)
    ax.set_aspect('equal')
    ax.legend(loc='lower right', fontsize=9)

    plt.tight_layout()
    plt.savefig('nyquist_q8.png', dpi=150, bbox_inches='tight')
    plt.show()
    print("Saved nyquist_q8.png")


if __name__ == "__main__":
    print("Generating Nyquist diagrams for 3F1 Lab Report...")
    print("\n1. Generating Nyquist diagram for Q1 (Manual Control)...")
    nyquist_manual_control()

    print("\n2. Generating Nyquist diagram for Q6 (Unstable Aircraft)...")
    nyquist_unstable_aircraft()

    print("\n3. Generating Nyquist diagram for Q8 (Unstable Aircraft with Delay)...")
    nyquist_unstable_with_delay()

    print("\nAll Nyquist diagrams generated successfully!")
