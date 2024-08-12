#
# Project : Lavender
# Source  : types.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/08/12
#

#=
### *Derived Types*
=#

"""
    Element{T}

Type definition. A matrix.
"""
const Element{T} = Array{T,2}

"""
    MatArray{T}

Type definition. A matrix of matrix.
"""
const MatArray{T} = Matrix{Element{T}}

"""
    VecArray{T}

Type definition. A vector of matrix.
"""
const VecArray{T} = Vector{Element{T}}

#=
### *Abstract Types*
=#

#=
*Remarks* :

We need a few abstract types to construct the type systems.These abstract
types include:

* *CnAbstractType*
* *CnAbstractMatrix*
* *CnAbstractVector*
* *CnAbstractFunction*

They should not be used in the user's applications directly.
=#

"""
    CnAbstractType

Top abstract type for all objects defined on contour.
"""
abstract type CnAbstractType end

"""
    CnAbstractMatrix{T}

Abstract matrix type defined on contour.
"""
abstract type CnAbstractMatrix{T} <: CnAbstractType end

"""
    CnAbstractVector{T}

Abstract vector type defined on contour.
"""
abstract type CnAbstractVector{T} <: CnAbstractType end

"""
    CnAbstractFunction{T}

Abstract contour function.
"""
abstract type CnAbstractFunction{T} <: CnAbstractType end

#=
*Remarks: Kadanoff-Baym Contour*

We adopt an 𝐿-shaped `Kadanoff-Baym` contour ``\mathcal{C}`` with
three branches:

* ``\mathcal{C}_1``: ``0 \longrightarrow t_{\text{max}}``
* ``\mathcal{C}_2``: ``t_{\text{max}} \longrightarrow 0``
* ``\mathcal{C}_3``: ``0 \longrightarrow -i\beta``

where ``t_{\text{max}}`` is the maximal time up to which one wants to
let the system evolve and ``\beta`` is the inverse temperature
(``\beta \equiv 1/T``).

The expectation value of an observable ``\mathcal{O}`` measured at time
``t`` is given by

```math
\begin{equation}
\langle \mathcal{O}(t) \rangle =
    \frac{\text{Tr}\left[
                   \mathcal{T}_{\mathcal{C}}
                   e^{-i\int_{\mathcal{C}} d\bar{t} \mathcal{H}(\bar{t})}
                   \mathcal{O}(t)
                   \right]}
         {\text{Tr}\left[
                   \mathcal{T}_{\mathcal{C}}
                   e^{-i\int_{\mathcal{C}} d\bar{t} \mathcal{H}(\bar{t})}
         \right]},
\end{equation}
```

where ``\mathcal{T}_{\mathcal{C}}`` is a contour-ordering operator
that arranges operators on the contour ``\mathcal{C}`` in the order
``0 \to t_{\text{max}} \to 0 \to -i\beta``, while ``\mathcal{T}_{\tau}``
is the time-ordering operator only on the imaginary-time axis.

The contour-ordered formalism reveals its full power when it is applied
to higher-order correlation functions,

```math
\begin{equation}
\langle \mathcal{T}_{\mathcal{C}} \mathcal{A}(t) \mathcal{B}(t') \rangle
    =
    \frac{1}{Z} \text{Tr}
    \left[
        \mathcal{T}_{\mathcal{C}}
        e^{-i\int_{\mathcal{C}} d\bar{t} \mathcal{H}(\bar{t})}
        \mathcal{A}(t) \mathcal{B}(t')
    \right].
\end{equation}
```

Here ``\mathcal{A}`` and ``\mathcal{B}`` are combinations of particle's
creation and annihilation operators. We call them ''fermionic'' if they
contain odd number of fermion's creation or annihilation operators, and
''bosonic'' otherwise. In this expression, ``t`` and ``t'`` can lie
anywhere on ``\mathcal{C}``, and the contour-ordered product of two
operators ``\mathcal{A}`` and ``\mathcal{B}`` is defined as

```math
\begin{equation}
\mathcal{T}_{\mathcal{C}} \mathcal{A}(t) \mathcal{B}(t')
    = \theta_{\mathcal{C}}(t,t') \mathcal{A}(t) \mathcal{B}(t')
    \pm \theta_{\mathcal{C}}(t',t) \mathcal{B}(t') \mathcal{A}(t),
\end{equation}
```

where ``\theta_{\mathcal{C}}(t,t') = 1`` when ``t'`` comes earlier than
``t`` in the contour ordering (denoted by ``t \succ t'``) and 0 otherwise
(``t \prec t'``). The sign ``\pm`` is taken to be minus when the operators
``\mathcal{A}`` and ``\mathcal{B}`` are both fermionic and plus otherwise.

---

*Remarks: Contour-ordered Green's Functions*

In the many-body theories, single-particle Green's functions are the
fundamental objects. They describe single-particle excitations as well
as statistical distributions of particles, and play a central role in
the formulation of nonequilibrium dynamical mean-field theory. We define
the nonequilibrium Green's function as the contour-ordered expectation
value,

```math
\begin{equation}
G(t,t') \equiv
    -i \langle \mathcal{T}_{\mathcal{C}} c(t) c^{\dagger}(t') \rangle,
\end{equation}
```

where ``c^{\dagger}(c)`` is a creation (annihilation) operators of
particles, and ``t,\ t' \in \mathcal{C}``. For simplicity, spin and
orbital indices associated with the operators are not shown. Because
of the three branches, on which the time arguments ``t`` and ``t'``
can lie, the Green's function has ``3 \times 3 = 9`` components:

```math
\begin{equation}
G(t,t') \equiv G_{ij}(t,t'),
\end{equation}
```

where ``t \in \mathcal{C}_i``, ``t' \in \mathcal{C}_j``, and
``i,\ j = 1,\ 2,\ 3``. Conventionally, we can express them in a
``3 \times 3`` matrix form

```math
\begin{equation}
\hat{G} =
\begin{pmatrix}
G_{11} & G_{12} & G_{13} \\
G_{21} & G_{22} & G_{23} \\
G_{31} & G_{32} & G_{33} \\
\end{pmatrix}.
\end{equation}
```

In general, one can shift the operator with the largest real-time
argument from ``\mathcal{C}_1`` to ``\mathcal{C}_2`` (and vice versa),
because the time evolution along ``\mathcal{C}_1`` and ``\mathcal{C}_2``
to the right of that operator cancels. This kind of redundancy implies
the following relations among the components of the above matrix:

```math
\begin{equation}
G_{11}(t,t') = G_{12}(t,t'),\ \text{for}\ t \le t',
\end{equation}
```

```math
\begin{equation}
G_{11}(t,t') = G_{21}(t,t'),\ \text{for}\ t > t',
\end{equation}
```

```math
\begin{equation}
G_{22}(t,t') = G_{21}(t,t'),\ \text{for}\ t < t',
\end{equation}
```

```math
\begin{equation}
G_{22}(t,t') = G_{12}(t,t'),\ \text{for}\ t \ge t',
\end{equation}
```

```math
\begin{equation}
G_{13}(t,\tau') = G_{23}(t,\tau'),
\end{equation}
```

```math
\begin{equation}
G_{31}(\tau,t') = G_{32}(\tau,t').
\end{equation}
```

The above equations can be summarized as

```math
\begin{equation}
G_{11} + G_{22} = G_{12} + G_{21}.
\end{equation}
```

These equations thus allow one to eliminate three components out of
nine in the nonequilibrium Green's function. To this end, we introduce
six linearly independent physical Green's functions, namely the retarded
(``G^{R}``), advanced (``G^{A}``), Keldysh (``G^{K}``), left-mixing
(``G^{\rceil}``), right-mixing (``G^{\lceil}``), and Matsubara Green's
functions (``G^{M}``). Their definitions and relevant properties will
be given in the following remarks if needed.
=#

#=
### *Cn* : *Struct*
=#

"""
    Cn

𝐿-shape `Kadanoff-Baym` contour. It includes the following members:

* ntime -> Number of time slices in real time axis [0, 𝑡max].
* ntau -> Number of time slices in imaginary time axis [0, β].
* ndim1 -> Size of operators that stored in the contour.
* ndim2 -> Size of operators that stored in the contour.
* tmax -> Maximum 𝑡.
* beta -> β, inverse temperature.
* dt -> δ𝑡, time step in real axis.
* dtau -> δτ, time step in imaginary axis.

See also: [`CnAbstractType`](@ref).
"""
mutable struct Cn <: CnAbstractType
    ntime :: I64
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    tmax  :: F64
    beta  :: F64
    dt    :: F64
    dtau  :: F64
end

#=
### *Cn* : *Constructors*
=#

"""
    Cn(ntime::I64, ntau::I64, ndim1::I64,
       ndim2::I64, tmax::F64, beta::F64)

Constructor. Create a general 𝐿-shape `Kadanoff-Baym` contour.
"""
function Cn(ntime::I64, ntau::I64, ndim1::I64,
            ndim2::I64, tmax::F64, beta::F64)
    # Sanity check
    @assert ntime ≥ 2
    @assert ntau  ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1
    @assert tmax  > 0.0
    @assert beta  > 0.0

    # Evaluate `dt` and `dtau`
    dt = tmax / ( ntime - 1 )
    dtau = beta / ( ntau - 1 )

    # Call the default constructor
    Cn(ntime, ntau, ndim1, ndim2, tmax, beta, dt, dtau)
end

"""
    Cn(ndim1::I64, ndim2::I64, tmax::F64, beta::F64)

Constructor. With default `ntime` (= 201) and `ntau` (= 1001). For
general matrix system.
"""
function Cn(ndim1::I64, ndim2::I64, tmax::F64, beta::F64)
    ntime = 201
    ntau = 1001
    Cn(ntime, ntau, ndim1, ndim2, tmax, beta)
end

"""
    Cn(ndim1::I64, tmax::F64, beta::F64)

Constructor. With default `ntime` (= 201) and `ntau` (= 1001). For
special square matrix system.
"""
function Cn(ndim1::I64, tmax::F64, beta::F64)
    ndim2 = ndim1
    Cn(ndim1, ndim2, tmax, beta)
end

"""
    Cn(tmax::F64, beta::F64)

Constructor. With default `ntime` (= 201) and `ntau` (= 1001). For
special single band system.
"""
function Cn(tmax::F64, beta::F64)
    ndim1 = 1
    ndim2 = 1
    Cn(ndim1, ndim2, tmax, beta)
end

#=
### *Cn* : *Properties*
=#

"""
    getdims(C::Cn)

Return the dimensional parameters of contour.

See also: [`Cn`](@ref).
"""
function getdims(C::Cn)
    return (C.ndim1, C.ndim2)
end

"""
    equaldims(C::Cn)

Return whether the dimensional parameters are equal.

See also: [`Cn`](@ref).
"""
function equaldims(C::Cn)
    return C.ndim1 == C.ndim2
end

#=
### *Cn* : *Operations*
=#

"""
    refresh!(C::Cn)

Update the `dt` and `dtau` parameters of contour.

See also: [`Cn`](@ref).
"""
function refresh!(C::Cn)
    # Sanity check
    @assert C.ntime ≥ 2
    @assert C.ntau ≥ 2

    # Evaluate `dt` and `dtau` again
    C.dt = C.tmax / ( C.ntime - 1 )
    C.dtau = C.beta / ( C.ntau - 1 )
end

#=
### *Cn* : *Traits*
=#

"""
    Base.show(io::IO, C::Cn)

Display `Cn` struct on the terminal.

See also: [`Cn`](@ref).
"""
function Base.show(io::IO, C::Cn)
    println("ntime : ", C.ntime)
    println("ntau  : ", C.ntau )
    println("ndim1 : ", C.ndim1)
    println("ndim2 : ", C.ndim2)
    println("tmax  : ", C.tmax )
    println("beta  : ", C.beta )
    println("dt    : ", C.dt   )
    println("dtau  : ", C.dtau )
end

#=
*Remarks: Contour-based Functions*

It is a general matrix-valued function defined at the `Kadanoff-Baym`
contour:

```math
\begin{equation}
f_{\mathcal{C}} = f(t),
\end{equation}
```

where ``t \in \mathcal{C}_1 \cup \mathcal{C}_2 \cup \mathcal{C}_3``.
=#

#=
### *Cf* : *Struct*
=#

"""
    Cf{T}

It is a square-matrix-valued or rectangle-matrix-valued function of time.

See also: [`ℱ`](@ref), [`𝒻`](@ref).
"""
mutable struct Cf{T} <: CnAbstractFunction{T}
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{T}
end

#=
### *Cf* : *Constructors*
=#

"""
    Cf(ntime::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Cf(ntime::I64, ndim1::I64, ndim2::I64, v::T) where {T}
    # Sanity check
    #
    # If `ntime = 0`, it means that the system stays at the equilibrium
    # state and this function is defined at the Matsubara axis only.
    @assert ntime ≥ 0
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create Element{T}
    element = fill(v, ndim1, ndim2)

    # Create VecArray{T}, whose size is indeed (ntime + 1,).
    #
    # Be careful, data[end] is the value of the function on the
    # Matsubara axis (initial state), while data[1:ntime] is for
    # the time evolution part.
    data = VecArray{T}(undef, ntime + 1)
    for i = 1:ntime + 1
        data[i] = copy(element)
    end

    # Call the default constructor
    Cf(ntime, ndim1, ndim2, data)
end

"""
    Cf(ntime::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Cf(ntime::I64, ndim1::I64, ndim2::I64)
    Cf(ntime, ndim1, ndim2, zero(C64))
end

"""
    Cf(ntime::I64, ndim1::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Cf(ntime::I64, ndim1::I64)
    Cf(ntime, ndim1, ndim1, zero(C64))
end

"""
    Cf(ntime::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Cf(ntime::I64, x::Element{T}) where {T}
    # Sanity check
    @assert ntime ≥ 0

    ndim1, ndim2 = size(x)
    data = VecArray{T}(undef, ntime + 1)
    for i = 1:ntime + 1
        data[i] = copy(x)
    end

    # Call the default constructor
    Cf(ntime, ndim1, ndim2, data)
end

"""
    Cf(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Cf(C::Cn, x::Element{T}) where {T}
    # Sanity check
    @assert getdims(C) == size(x)

    # Create VecArray{T}, whose size is indeed (ntime + 1,).
    data = VecArray{T}(undef, C.ntime + 1)
    for i = 1:C.ntime + 1
        data[i] = copy(x)
    end

    # Call the default constructor
    Cf(C.ntime, C.ndim1, C.ndim2, data)
end

"""
    Cf(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Cf(C::Cn, v::T) where {T}
    Cf(C.ntime, C.ndim1, C.ndim2, v)
end

"""
    Cf(C::Cn)

Constructor. All the matrix elements are set to be complex zero.
"""
function Cf(C::Cn)
    Cf(C.ntime, C.ndim1, C.ndim2, zero(C64))
end

#=
### *Cf* : *Properties*
=#

"""
    getdims(cf::Cf{T})

Return the dimensional parameters of contour function.

See also: [`Cf`](@ref).
"""
function getdims(cf::Cf{T}) where {T}
    return (cf.ndim1, cf.ndim2)
end

"""
    getsize(cf::Cf{T})

Return the nominal size of contour function, i.e `ntime`. Actually, the
real size of contour function should be `ntime + 1`.

See also: [`Cf`](@ref).
"""
function getsize(cf::Cf{T}) where {T}
    return cf.ntime
end

"""
    equaldims(cf::Cf{T})

Return whether the dimensional parameters are equal.

See also: [`Cf`](@ref).
"""
function equaldims(cf::Cf{T}) where {T}
    return cf.ndim1 == cf.ndim2
end

"""
    iscompatible(cf1::Cf{T}, cf2::Cf{T})

Judge whether two `Cf` objects are compatible.
"""
function iscompatible(cf1::Cf{T}, cf2::Cf{T}) where {T}
    getsize(cf1) == getsize(cf2) &&
    getdims(cf1) == getdims(cf2)
end

"""
    iscompatible(C::Cn, cf::Cf{T})

Judge whether `C` (which is a `Cn` object) is compatible with `cf`
(which is a `Cf{T}` object).
"""
function iscompatible(C::Cn, cf::Cf{T}) where {T}
    C.ntime == getsize(cf) &&
    getdims(C) == getdims(cf)
end

"""
    iscompatible(cf::Cf{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `cf`
(which is a `Cf{T}` object).
"""
iscompatible(cf::Cf{T}, C::Cn) where {T} = iscompatible(C, cf)

#=
### *Cf* : *Indexing*
=#

"""
    Base.getindex(cf::Cf{T}, i::I64)

Visit the element stored in `Cf` object. If `i = 0`, it returns
the element at Matsubara axis. On the other hand, if `i > 0`, it will
return elements at real time axis.
"""
function Base.getindex(cf::Cf{T}, i::I64) where {T}
    # Sanity check
    @assert 0 ≤ i ≤ cf.ntime

    # Return 𝑓(𝑡ᵢ)
    if i == 0 # Matsubara axis
        cf.data[end]
    else # Real time axis
        cf.data[i]
    end
end

"""
    Base.setindex!(cf::Cf{T}, x::Element{T}, i::I64)

Setup the element in `Cf` object. If `i = 0`, it will setup the
element at Matsubara axis to `x`. On the other hand, if `i > 0`, it
will setup elements at real time axis.
"""
function Base.setindex!(cf::Cf{T}, x::Element{T}, i::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(cf)
    @assert 0 ≤ i ≤ cf.ntime

    # 𝑓(𝑡ᵢ) = x
    if i == 0 # Matsubara axis
        cf.data[end] = copy(x)
    else # Real time axis
        cf.data[i] = copy(x)
    end
end

"""
    Base.setindex!(cf::Cf{T}, v::T, i::I64)

Setup the element in `Cf` object. If `i = 0`, it will setup the
element at Matsubara axis to `v`. On the other hand, if `i > 0`, it
will setup elements at real time axis. Here, `v` should be a scalar
number.
"""
function Base.setindex!(cf::Cf{T}, v::T, i::I64) where {T}
    # Sanity check
    @assert 0 ≤ i ≤ cf.ntime

    # 𝑓(𝑡ᵢ) .= v
    if i == 0 # Matsubara axis
        fill!(cf.data[end], v)
    else # Real time axis
        fill!(cf.data[i], v)
    end
end

#=
### *Cf* : *Operations*
=#

"""
    memset!(cf::Cf{T}, x)

Reset all the matrix elements of `cf` to `x`. `x` should be a
scalar number.
"""
function memset!(cf::Cf{T}, x) where {T}
    cx = convert(T, x)
    for i = 1:cf.ntime + 1
        fill!(cf.data[i], cx)
    end
end

"""
    zeros!(cf::Cf{T})

Reset all the matrix elements of `cf` to `zero`.
"""
zeros!(cf::Cf{T}) where {T} = memset!(cf, zero(T))

"""
    memcpy!(src::Cf{T}, dst::Cf{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::Cf{T}, dst::Cf{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    incr!(cf1::Cf{T}, cf2::Cf{T}, α::T)

Add a `Cf` with given weight (`α`) to another `Cf`. Finally,
`cf1` will be changed.
"""
function incr!(cf1::Cf{T}, cf2::Cf{T}, α::T) where {T}
    @assert iscompatible(cf1, cf2)
    for i = 1:cf1.ntime + 1
        @. cf1.data[i] = cf1.data[i] + cf2.data[i] * α
    end
end

"""
    smul!(cf::Cf{T}, α::T)

Multiply a `Cf` with given weight (`α`).
"""
function smul!(cf::Cf{T}, α::T) where {T}
    for i = 1:cf.ntime + 1
        @. cf.data[i] = cf.data[i] * α
    end
end

"""
    smul!(x::Element{T}, cf::Cf{T})

Left multiply a `Cf` with given weight (`x`).
"""
function smul!(x::Element{T}, cf::Cf{T}) where {T}
    for i = 1:cf.ntime + 1
        cf.data[i] = x * cf.data[i]
    end
end

"""
    smul!(cf::Cf{T}, x::Element{T})

Right multiply a `Cf` with given weight (`x`).
"""
function smul!(cf::Cf{T}, x::Element{T}) where {T}
    for i = 1:cf.ntime + 1
        cf.data[i] = cf.data[i] * x
    end
end

#=
### *Cf* : *Traits*
=#

"""
    Base.:+(cf1::Cf{T}, cf2::Cf{T})

Operation `+` for two `Cf` objects.
"""
function Base.:+(cf1::Cf{T}, cf2::Cf{T}) where {T}
    # Sanity check
    @assert getsize(cf1) == getsize(cf2)
    @assert getdims(cf1) == getdims(cf2)

    Cf(cf1.ntime, cf1.ndim1, cf1.ndim2, cf1.data + cf2.data)
end

"""
    Base.:-(cf1::Cf{T}, cf2::Cf{T})

Operation `-` for two `Cf` objects.
"""
function Base.:-(cf1::Cf{T}, cf2::Cf{T}) where {T}
    # Sanity check
    @assert getsize(cf1) == getsize(cf2)
    @assert getdims(cf1) == getdims(cf2)

    Cf(cf1.ntime, cf1.ndim1, cf1.ndim2, cf1.data - cf2.data)
end

"""
    Base.:*(cf::Cf{T}, x)

Operation `*` for a `Cf` object and a scalar value.
"""
function Base.:*(cf::Cf{T}, x) where {T}
    cx = convert(T, x)
    Cf(cf.ntime, cf.ndim1, cf.ndim2, cf.data * cx)
end

"""
    Base.:*(x, cf::Cf{T})

Operation `*` for a scalar value and a `Cf` object.
"""
Base.:*(x, cf::Cf{T}) where {T} = Base.:*(cf, x)

#=
*Remarks: Matsubara Green's Function*

The Matsubara component of contour Green's function reads

```math
\begin{equation}
G^{M}(\tau, \tau') =
    -\langle \mathcal{T}_{\tau} c(\tau) c^{\dagger}(\tau') \rangle,
\end{equation}
```

where ``\tau`` and ``\tau'`` lie in ``\mathcal{C}_3``.

Note that the Matsubara component ``G^{M}`` plays a somewhat special
role, since it is always translationally invariant (``\mathcal{H}``
does not depend on imaginary time):

```math
\begin{equation}
G^{M}(\tau,\tau') \equiv G^{M}(\tau - \tau').
\end{equation}
```

Furthermore, it is real (Hermitian),

```math
\begin{equation}
G^{M}(\tau)^{*} = G^{M}(\tau),
\end{equation}
```

and it is also periodic (antiperiodic) for bosons (fermions),

```math
\begin{equation}
G^{M}(\tau) = \pm G^{M}(\tau + \beta).
\end{equation}
```

One can thus use its Fourier decomposition in terms of Matsubara
frequencies

```math
\begin{equation}
G^{M}(\tau,\tau') =
    T \sum_n e^{-i\omega_n(\tau-\tau')} G^{M}(i\omega_n),
\end{equation}
```

and

```math
\begin{equation}
G^{M}(i\omega_n) = \int^{\beta}_0 d\tau e^{i\omega_n}G^{M}(\tau).
\end{equation}
```
=#

#=
### *Gᵐᵃᵗ* : *Struct*
=#

"""
    Gᵐᵃᵗ{T}

Matsubara component (``G^M``) of contour Green's function. We usually
call this component `mat`. Here we just assume ``\tau ≥ 0``. While for
``\tau < 0``, please turn to the `Gᵐᵃᵗᵐ{T}` struct.

See also: [`Gʳᵉᵗ`](@ref), [`Gˡᵐⁱˣ`](@ref), [`Gˡᵉˢˢ`](@ref).
"""
mutable struct Gᵐᵃᵗ{T} <: CnAbstractMatrix{T}
    type  :: String
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *Gᵐᵃᵗ* : *Constructors*
=#

"""
    Gᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Gᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64, v::T) where {T}
    # Sanity check
    @assert ntau  ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create Element{T}
    element = fill(v, ndim1, ndim2)

    # Create MatArray{T}, whose size is indeed (ntau, 1).
    data = MatArray{T}(undef, ntau, 1)
    for i=1:ntau
        data[i,1] = copy(element)
    end

    # Call the default constructor
    Gᵐᵃᵗ("mat", ntau, ndim1, ndim2, data)
end

"""
    Gᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64)
    Gᵐᵃᵗ(ntau, ndim1, ndim2, zero(C64))
end

"""
    Gᵐᵃᵗ(ntau::I64, ndim1::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gᵐᵃᵗ(ntau::I64, ndim1::I64)
    Gᵐᵃᵗ(ntau, ndim1, ndim1, zero(C64))
end

"""
    Gᵐᵃᵗ(ntau::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Gᵐᵃᵗ(ntau::I64, x::Element{T}) where {T}
    # Sanity check
    @assert ntau ≥ 2

    ndim1, ndim2 = size(x)
    data = MatArray{T}(undef, ntau, 1)
    for i=1:ntau
        data[i,1] = copy(x)
    end

    # Call the default constructor
    Gᵐᵃᵗ("mat", ntau, ndim1, ndim2, data)
end

"""
    Gᵐᵃᵗ(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Gᵐᵃᵗ(C::Cn, x::Element{T}) where {T}
    # Sanity check
    @assert getdims(C) == size(x)

    # Create MatArray{T}, whose size is indeed (ntau, 1).
    data = MatArray{T}(undef, C.ntau, 1)
    for i=1:C.ntau
        data[i,1] = copy(x)
    end

    # Call the default constructor
    Gᵐᵃᵗ("mat", C.ntau, C.ndim1, C.ndim2, data)
end

"""
    Gᵐᵃᵗ(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Gᵐᵃᵗ(C::Cn, v::T) where {T}
    Gᵐᵃᵗ(C.ntau, C.ndim1, C.ndim2, v)
end

"""
    Gᵐᵃᵗ(C::Cn)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gᵐᵃᵗ(C::Cn)
    Gᵐᵃᵗ(C.ntau, C.ndim1, C.ndim2, zero(C64))
end

#=
### *Gᵐᵃᵗ* : *Properties*
=#

"""
    getdims(mat::Gᵐᵃᵗ{T})

Return the dimensional parameters of contour function.

See also: [`Gᵐᵃᵗ`](@ref).
"""
function getdims(mat::Gᵐᵃᵗ{T}) where {T}
    return (mat.ndim1, mat.ndim2)
end

"""
    getsize(mat::Gᵐᵃᵗ{T})

Return the size of contour function. Here, it should be `ntau`.

See also: [`Gᵐᵃᵗ`](@ref).
"""
function getsize(mat::Gᵐᵃᵗ{T}) where {T}
    return mat.ntau
end

"""
    equaldims(mat::Gᵐᵃᵗ{T})

Return whether the dimensional parameters are equal.

See also: [`Gᵐᵃᵗ`](@ref).
"""
function equaldims(mat::Gᵐᵃᵗ{T}) where {T}
    return mat.ndim1 == mat.ndim2
end

"""
    iscompatible(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T})

Judge whether two `Gᵐᵃᵗ` objects are compatible.
"""
function iscompatible(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T}) where {T}
    getsize(mat1) == getsize(mat2) &&
    getdims(mat1) == getdims(mat2)
end

"""
    iscompatible(C::Cn, mat::Gᵐᵃᵗ{T})

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `Gᵐᵃᵗ{T}` object).
"""
function iscompatible(C::Cn, mat::Gᵐᵃᵗ{T}) where {T}
    C.ntau == getsize(mat) &&
    getdims(C) == getdims(mat)
end

"""
    iscompatible(mat::Gᵐᵃᵗ{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `Gᵐᵃᵗ{T}` object).
"""
iscompatible(mat::Gᵐᵃᵗ{T}, C::Cn) where {T} = iscompatible(C, mat)

"""
    distance(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T})

Calculate distance between two `Gᵐᵃᵗ` objects.
"""
function distance(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T}) where {T}
    @assert iscompatible(mat1, mat2)

    err = 0.0
    #
    for m = 1:mat1.ntau
        err = err + abs(sum(mat1.data[m,1] - mat2.data[m,1]))
    end
    #
    return err
end

#=
### *Gᵐᵃᵗ* : *Indexing*
=#

"""
    Base.getindex(mat::Gᵐᵃᵗ{T}, ind::I64)

Visit the element stored in `Gᵐᵃᵗ` object.
"""
function Base.getindex(mat::Gᵐᵃᵗ{T}, ind::I64) where {T}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # Return G^{M}(τᵢ ≥ 0)
    mat.data[ind,1]
end

"""
    Base.setindex!(mat::Gᵐᵃᵗ{T}, x::Element{T}, ind::I64)

Setup the element in `Gᵐᵃᵗ` object.
"""
function Base.setindex!(mat::Gᵐᵃᵗ{T}, x::Element{T}, ind::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(mat)
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) = x
    mat.data[ind,1] = copy(x)
end

"""
    Base.setindex!(mat::Gᵐᵃᵗ{T}, v::T, ind::I64)

Setup the element in `Gᵐᵃᵗ` object.
"""
function Base.setindex!(mat::Gᵐᵃᵗ{T}, v::T, ind::I64) where {T}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) .= v
    fill!(mat.data[ind,1], v)
end

#=
### *Gᵐᵃᵗ* : *Operations*
=#

"""
    memset!(mat::Gᵐᵃᵗ{T}, x)

Reset all the matrix elements of `mat` to `x`. `x` should be a
scalar number.
"""
function memset!(mat::Gᵐᵃᵗ{T}, x) where {T}
    cx = convert(T, x)
    for i = 1:mat.ntau
        fill!(mat.data[i,1], cx)
    end
end

"""
    zeros!(mat::Gᵐᵃᵗ{T})

Reset all the matrix elements of `mat` to `zero`.
"""
zeros!(mat::Gᵐᵃᵗ{T}) where {T} = memset!(mat, zero(T))

"""
    memcpy!(src::Gᵐᵃᵗ{T}, dst::Gᵐᵃᵗ{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::Gᵐᵃᵗ{T}, dst::Gᵐᵃᵗ{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    incr!(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T}, α::T)

Add a `Gᵐᵃᵗ` with given weight (`α`) to another `Gᵐᵃᵗ`.

```math
G^M_1 ⟶ G^M_1 + α * G^M_2.
```
"""
function incr!(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T}, α::T) where {T}
    @assert iscompatible(mat1, mat2)
    for i = 1:mat2.ntau
        @. mat1.data[i,1] = mat1.data[i,1] + mat2.data[i,1] * α
    end
end

"""
    smul!(mat::Gᵐᵃᵗ{T}, α::T)

Multiply a `Gᵐᵃᵗ` with given weight (`α`).

```math
G^M ⟶ α * G^M.
```
"""
function smul!(mat::Gᵐᵃᵗ{T}, α::T) where {T}
    for i = 1:mat.ntau
        @. mat.data[i,1] = mat.data[i,1] * α
    end
end

"""
    smul!(x::Element{T}, mat::Gᵐᵃᵗ{T})

Left multiply a `Gᵐᵃᵗ` with given weight (`x`), which is actually a
matrix.
"""
function smul!(x::Element{T}, mat::Gᵐᵃᵗ{T}) where {T}
    for i = 1:mat.ntau
        mat.data[i,1] = x * mat.data[i,1]
    end
end

"""
    smul!(mat::Gᵐᵃᵗ{T}, x::Element{T})

Right multiply a `Gᵐᵃᵗ` with given weight (`x`), which is actually a
matrix.
"""
function smul!(mat::Gᵐᵃᵗ{T}, x::Element{T}) where {T}
    for i = 1:mat.ntau
        mat.data[i,1] = mat.data[i,1] * x
    end
end

#=
### *Gᵐᵃᵗ* : *Traits*
=#

"""
    Base.:+(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T})

Operation `+` for two `Gᵐᵃᵗ` objects.
"""
function Base.:+(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T}) where {T}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    Gᵐᵃᵗ(mat1.type, mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data + mat2.data)
end

"""
    Base.:-(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T})

Operation `-` for two `Gᵐᵃᵗ` objects.
"""
function Base.:-(mat1::Gᵐᵃᵗ{T}, mat2::Gᵐᵃᵗ{T}) where {T}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    Gᵐᵃᵗ(mat1.type, mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data - mat2.data)
end

"""
    Base.:*(mat::Gᵐᵃᵗ{T}, x)

Operation `*` for a `Gᵐᵃᵗ` object and a scalar value.
"""
function Base.:*(mat::Gᵐᵃᵗ{T}, x) where {T}
    cx = convert(T, x)
    Gᵐᵃᵗ(mat.type, mat.ntau, mat.ndim1, mat.ndim2, mat.data * cx)
end

"""
    Base.:*(x, mat::Gᵐᵃᵗ{T})

Operation `*` for a scalar value and a `Gᵐᵃᵗ` object.
"""
Base.:*(x, mat::Gᵐᵃᵗ{T}) where {T} = Base.:*(mat, x)

#=
*Remarks: Retarded Green's Function*

The retarded component of contour Green's function reads

```math
\begin{equation}
G^{R}(t,t') =
    -i \theta(t-t') \langle [c(t), c^{\dagger}(t')]_{\mp} \rangle,
\end{equation}
```

Here, ``t``, ``t'`` belong to ``\mathcal{C}_1 ∪ \mathcal{C}_2``,
``\theta(t)`` is a step function, ``[,]_{-(+)}`` denotes an
(anti-)commutator. We choose the -(+) sign if the operators ``c``
and ``c^{\dagger}`` are bosonic (fermionic).

The retarded component is related to the advanced component by
hermitian conjugate:

```math
\begin{equation}
G^{R}(t,t') = G^{A}(t',t)^{*},
\end{equation}
```

and

```math
\begin{equation}
G^{R}(t,t')^{*} = G^{A}(t',t).
\end{equation}
```

The retarded component can be calculated with the lesser and greater
components:

```math
\begin{equation}
G^{R}(t,t') = \theta(t-t')[G^{>}(t,t') - G^{<}(t,t')].
\end{equation}
```

Note that ``G^{R}(t,t') = 0`` if ``t' > t``, which expresses the causality
of the retarded component. However, for the implementation of numerical
algorithms, it can be more convenient to drop the Heaviside function in
the above equation. Therefore, we define a modified retarded component by

```math
\begin{equation}
\tilde{G}^{R}(t,t') = G^{>}(t,t') - G^{<}(t,t').
\end{equation}
```

Its hermitian conjugate is as follows:

```math
\begin{equation}
\tilde{G}^{R}(t,t') = -\tilde{G}^{R}(t',t)^{*}.
\end{equation}
```
=#

#=
### *Gʳᵉᵗ* : *Struct*
=#

"""
    Gʳᵉᵗ{T}

Retarded component (``G^R``) of contour Green's function. We usually
call this component `ret`.

See also: [`Gᵐᵃᵗ`](@ref), [`Gˡᵐⁱˣ`](@ref), [`Gˡᵉˢˢ`](@ref).
"""
mutable struct Gʳᵉᵗ{T} <: CnAbstractMatrix{T}
    type  :: String
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *Gʳᵉᵗ* : *Constructors*
=#

"""
    Gʳᵉᵗ(ntime::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Gʳᵉᵗ(ntime::I64, ndim1::I64, ndim2::I64, v::T) where {T}
    # Sanity check
    @assert ntime ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create Element{T}
    element = fill(v, ndim1, ndim2)

    # Create MatArray{T}, whose size is indeed (ntime, ntime).
    data = MatArray{T}(undef, ntime, ntime)
    for i = 1:ntime
        for j = 1:ntime
            data[j,i] = copy(element)
        end
    end

    # Call the default constructor
    Gʳᵉᵗ("ret", ntime, ndim1, ndim2, data)
end

"""
    Gʳᵉᵗ(ntime::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gʳᵉᵗ(ntime::I64, ndim1::I64, ndim2::I64)
    Gʳᵉᵗ(ntime, ndim1, ndim2, zero(C64))
end

"""
    Gʳᵉᵗ(ntime::I64, ndim1::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gʳᵉᵗ(ntime::I64, ndim1::I64)
    Gʳᵉᵗ(ntime, ndim1, ndim1, zero(C64))
end

"""
    Gʳᵉᵗ(ntime::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Gʳᵉᵗ(ntime::I64, x::Element{T}) where {T}
    # Sanity check
    @assert ntime ≥ 2

    ndim1, ndim2 = size(x)
    data = MatArray{T}(undef, ntime, ntime)
    for i = 1:ntime
        for j = 1:ntime
            data[j,i] = copy(x)
        end
    end

    # Call the default constructor
    Gʳᵉᵗ("ret", ntime, ndim1, ndim2, data)
end

"""
    Gʳᵉᵗ(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Gʳᵉᵗ(C::Cn, x::Element{T}) where {T}
    # Sanity check
    @assert getdims(C) == size(x)

    # Create MatArray{T}, whose size is indeed (ntime, ntime).
    data = MatArray{T}(undef, C.ntime, C.ntime)
    for i = 1:C.ntime
        for j = 1:C.ntime
            data[j,i] = copy(x)
        end
    end

    # Call the default constructor
    Gʳᵉᵗ("ret", C.ntime, C.ndim1, C.ndim2, data)
end

"""
    Gʳᵉᵗ(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Gʳᵉᵗ(C::Cn, v::T) where {T}
    Gʳᵉᵗ(C.ntime, C.ndim1, C.ndim2, v)
end

"""
    Gʳᵉᵗ(C::Cn)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gʳᵉᵗ(C::Cn)
    Gʳᵉᵗ(C.ntime, C.ndim1, C.ndim2, zero(C64))
end

#=
### *Gʳᵉᵗ* : *Properties*
=#

"""
    getdims(ret::Gʳᵉᵗ{T})

Return the dimensional parameters of contour function.

See also: [`Gʳᵉᵗ`](@ref).
"""
function getdims(ret::Gʳᵉᵗ{T}) where {T}
    return (ret.ndim1, ret.ndim2)
end

"""
    getsize(ret::Gʳᵉᵗ{T})

Return the size of contour function.

See also: [`Gʳᵉᵗ`](@ref).
"""
function getsize(ret::Gʳᵉᵗ{T}) where {T}
    return ret.ntime
end

"""
    equaldims(ret::Gʳᵉᵗ{T})

Return whether the dimensional parameters are equal.

See also: [`Gʳᵉᵗ`](@ref).
"""
function equaldims(ret::Gʳᵉᵗ{T}) where {T}
    return ret.ndim1 == ret.ndim2
end

"""
    iscompatible(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T})

Judge whether two `Gʳᵉᵗ` objects are compatible.
"""
function iscompatible(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T}) where {T}
    getsize(ret1) == getsize(ret2) &&
    getdims(ret1) == getdims(ret2)
end

"""
    iscompatible(C::Cn, ret::Gʳᵉᵗ{T})

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `Gʳᵉᵗ{T}` object).
"""
function iscompatible(C::Cn, ret::Gʳᵉᵗ{T}) where {T}
    C.ntime == getsize(ret) &&
    getdims(C) == getdims(ret)
end

"""
    iscompatible(ret::Gʳᵉᵗ{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `Gʳᵉᵗ{T}` object).
"""
iscompatible(ret::Gʳᵉᵗ{T}, C::Cn) where {T} = iscompatible(C, ret)

"""
    distance(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T}, tstp::I64)

Calculate distance between two `Gʳᵉᵗ` objects at given time step `tstp`.
"""
function distance(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T}, tstp::I64) where {T}
    # Sanity check
    @assert 1 ≤ tstp ≤ ret1.ntime

    err = 0
    #
    for i = 1:tstp
        err = err + abs(sum(ret1.data[tstp,i] - ret2.data[tstp,i]))
    end
    #
    return err
end

#=
### *Gʳᵉᵗ* : *Indexing*
=#

#=
*Remarks* :

In principle, when ``t < t'``, ``G^{R}(t,t') \equiv 0``. Here, we assume
that the modified retarded component also fulfills the following hermitian
conjugate relation:

```math
\begin{equation}
\tilde{G}^{R}(t,t') = - \tilde{G}^{R}(t',t)^{*}
\end{equation}
```

See [`NESSi`] Eq.~(20) for more details.
=#

"""
    Base.getindex(ret::Gʳᵉᵗ{T}, i::I64, j::I64)

Visit the element stored in `Gʳᵉᵗ` object. Here `i` and `j` are indices
for real times.
"""
function Base.getindex(ret::Gʳᵉᵗ{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ ret.ntime
    @assert 1 ≤ j ≤ ret.ntime

    # Return G^{R}(tᵢ, tⱼ)
    if i ≥ j
        ret.data[i,j]
    else
        -ret.data'[i,j]
    end
end

"""
    Base.setindex!(ret::Gʳᵉᵗ{T}, x::Element{T}, i::I64, j::I64)

Setup the element in `Gʳᵉᵗ` object.
"""
function Base.setindex!(ret::Gʳᵉᵗ{T}, x::Element{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(ret)
    @assert 1 ≤ i ≤ ret.ntime
    @assert 1 ≤ j ≤ ret.ntime

    # G^{R}(tᵢ, tⱼ) = x
    ret.data[i,j] = copy(x)
end

"""
    Base.setindex!(ret::Gʳᵉᵗ{T}, v::T, i::I64, j::I64)

Setup the element in `Gʳᵉᵗ` object.
"""
function Base.setindex!(ret::Gʳᵉᵗ{T}, v::T, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ ret.ntime
    @assert 1 ≤ j ≤ ret.ntime

    # G^{R}(tᵢ, tⱼ) .= v
    fill!(ret.data[i,j], v)
end

#=
### *Gʳᵉᵗ* : *Operations*
=#

"""
    memset!(ret::Gʳᵉᵗ{T}, x)

Reset all the matrix elements of `ret` to `x`. `x` should be a
scalar number.
"""
function memset!(ret::Gʳᵉᵗ{T}, x) where {T}
    cx = convert(T, x)
    for i=1:ret.ntime
        for j=1:ret.ntime
            fill!(ret.data[j,i], cx)
        end
    end
end

"""
    memset!(ret::Gʳᵉᵗ{T}, tstp::I64, x)

Reset the matrix elements of `ret` at given time step `tstp` (and at all
`t` where `t < tstp`) to `x`. `x` should be a scalar number.
"""
function memset!(ret::Gʳᵉᵗ{T}, tstp::I64, x) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    cx = convert(T, x)
    for i=1:tstp
        fill!(ret.data[tstp,i], cx)
    end
end

"""
    zeros!(ret::Gʳᵉᵗ{T})

Reset all the matrix elements of `ret` to `zero`.
"""
zeros!(ret::Gʳᵉᵗ{T}) where {T} = memset!(ret, zero(T))

"""
    zeros!(ret::Gʳᵉᵗ{T}, tstp::I64)

Reset the matrix elements of `ret` at given time step `tstp` (and at all
`t` where `t < tstp`) to `zero`.
"""
zeros!(ret::Gʳᵉᵗ{T}, tstp::I64) where {T} = memset!(ret, tstp, zero(T))

"""
    memcpy!(src::Gʳᵉᵗ{T}, dst::Gʳᵉᵗ{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::Gʳᵉᵗ{T}, dst::Gʳᵉᵗ{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::Gʳᵉᵗ{T}, dst::Gʳᵉᵗ{T}, tstp::I64)

Copy some matrix elements from `src` to `dst`. Only the matrix elements
at given time step `tstp` (and at all `t` where `t < tstp`) are copied.
"""
function memcpy!(src::Gʳᵉᵗ{T}, dst::Gʳᵉᵗ{T}, tstp::I64) where {T}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    for i=1:tstp
        dst.data[tstp,i] = copy(src.data[tstp,i])
    end
end

"""
    incr!(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T}, tstp::I64, α::T)

Add a `Gʳᵉᵗ` with given weight (`α`) at given time step `tstp` (and at all
`t` where `t < tstp`) to another `Gʳᵉᵗ`.
"""
function incr!(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T}, tstp::I64, α::T) where {T}
    @assert iscompatible(ret1, ret2)
    @assert 1 ≤ tstp ≤ ret2.ntime
    for i = 1:tstp
        @. ret1.data[tstp,i] = ret1.data[tstp,i] + ret2.data[tstp,i] * α
    end
end

"""
    smul!(ret::Gʳᵉᵗ{T}, tstp::I64, α::T)

Multiply a `Gʳᵉᵗ` with given weight (`α`) at given time step `tstp` (and
at all `t` where `t < tstp`).
"""
function smul!(ret::Gʳᵉᵗ{T}, tstp::I64, α::T) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    for i = 1:tstp
        @. ret.data[tstp,i] = ret.data[tstp,i] * α
    end
end

"""
    smul!(x::Element{T}, ret::Gʳᵉᵗ{T}, tstp::I64)

Left multiply a `Gʳᵉᵗ` with given weight (`x`) at given time step `tstp`
(and at all `t` where `t < tstp`).
"""
function smul!(x::Element{T}, ret::Gʳᵉᵗ{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    for i = 1:tstp
        ret.data[tstp,i] = x * ret.data[tstp,i]
    end
end

"""
    smul!(ret::Gʳᵉᵗ{T}, x::Cf{T}, tstp::I64)

Right multiply a `Gʳᵉᵗ` with given weight (`x`) at given time step `tstp`
(and at all `t` where `t < tstp`).
"""
function smul!(ret::Gʳᵉᵗ{T}, x::Cf{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    for i = 1:tstp
        ret.data[tstp,i] = ret.data[tstp,i] * x[i]
    end
end

#=
### *Gʳᵉᵗ* : *Traits*
=#

"""
    Base.:+(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T})

Operation `+` for two `Gʳᵉᵗ` objects.
"""
function Base.:+(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T}) where {T}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    Gʳᵉᵗ(ret1.type, ret1.ntime, ret1.ndim1, ret1.ndim2, ret1.data + ret2.data)
end

"""
    Base.:-(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T})

Operation `-` for two `Gʳᵉᵗ` objects.
"""
function Base.:-(ret1::Gʳᵉᵗ{T}, ret2::Gʳᵉᵗ{T}) where {T}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    Gʳᵉᵗ(ret1.type, ret1.ntime, ret1.ndim1, ret1.ndim2, ret1.data - ret2.data)
end

"""
    Base.:*(ret::Gʳᵉᵗ{T}, x)

Operation `*` for a `Gʳᵉᵗ` object and a scalar value.
"""
function Base.:*(ret::Gʳᵉᵗ{T}, x) where {T}
    cx = convert(T, x)
    Gʳᵉᵗ(ret.type, ret.ntime, ret.ndim1, ret.ndim2, ret.data * cx)
end

"""
    Base.:*(x, ret::Gʳᵉᵗ{T})

Operation `*` for a scalar value and a `Gʳᵉᵗ` object.
"""
Base.:*(x, ret::Gʳᵉᵗ{T}) where {T} = Base.:*(ret, x)

#=
*Remarks: Left-mixing Green's Function*

The left-mixing component of contour Green's function reads

```math
\begin{equation}
G^{\rceil}(t,\tau') = \mp i \langle c^{\dagger}(\tau') c(t) \rangle,
\end{equation}
```

where ``t \in \mathcal{C}_1 \cup \mathcal{C}_2`` and
``\tau' \in \mathcal{C}_3``. We choose the upper
(lower) sign if the operators ``c`` and ``c^{\dagger}`` are bosonic
(fermionic). Its hermitian conjugate yields

```math
\begin{equation}
G^{\rceil}(t,\tau)^{*} = \mp G^{\lceil}(\beta - \tau,t),
\end{equation}
```

where ``G^{\lceil}(\tau,t')`` is the right-mixing Green's function.
=#

#=
### *Gˡᵐⁱˣ* : *Struct*
=#

"""
    Gˡᵐⁱˣ{T}

Left-mixing component (``G^{⌉}``) of contour Green's function. We usually
call this component `lmix`.

See also: [`Gᵐᵃᵗ`](@ref), [`Gʳᵉᵗ`](@ref), [`Gˡᵉˢˢ`](@ref).
"""
mutable struct Gˡᵐⁱˣ{T} <: CnAbstractMatrix{T}
    type  :: String
    ntime :: I64
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *Gˡᵐⁱˣ* : *Constructors*
=#

"""
    Gˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Gˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64, v::T) where {T}
    # Sanity check
    @assert ntime ≥ 2
    @assert ntau  ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create Element{T}
    element = fill(v, ndim1, ndim2)

    # Create MatArray{T}, whose size is indeed (ntime, ntau).
    data = MatArray{T}(undef, ntime, ntau)
    for i = 1:ntau
        for j = 1:ntime
            data[j,i] = copy(element)
        end
    end

    # Call the default constructor
    Gˡᵐⁱˣ("lmix", ntime, ntau, ndim1, ndim2, data)
end

"""
    Gˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64)
    Gˡᵐⁱˣ(ntime, ntau, ndim1, ndim2, zero(C64))
end

"""
    Gˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64)
    Gˡᵐⁱˣ(ntime, ntau, ndim1, ndim1, zero(C64))
end

"""
    Gˡᵐⁱˣ(ntime::I64, ntau::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Gˡᵐⁱˣ(ntime::I64, ntau::I64, x::Element{T}) where {T}
    # Sanity check
    @assert ntime ≥ 2
    @assert ntau  ≥ 2

    ndim1, ndim2 = size(x)
    data = MatArray{T}(undef, ntime, ntau)
    for i = 1:ntau
        for j = 1:ntime
            data[j,i] = copy(x)
        end
    end

    # Call the default constructor
    Gˡᵐⁱˣ("lmix", ntime, ntau, ndim1, ndim2, data)
end

"""
    Gˡᵐⁱˣ(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Gˡᵐⁱˣ(C::Cn, x::Element{T}) where {T}
    # Sanity check
    @assert getdims(C) == size(x)

    # Create MatArray{T}, whose size is indeed (ntime, ntau)
    data = MatArray{T}(undef, C.ntime, C.ntau)
    for i = 1:C.ntau
        for j = 1:C.ntime
            data[j,i] = copy(x)
        end
    end

    # Call the default constructor
    Gˡᵐⁱˣ("lmix", C.ntime, C.ntau, C.ndim1, C.ndim2, data)
end

"""
    Gˡᵐⁱˣ(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Gˡᵐⁱˣ(C::Cn, v::T) where {T}
    Gˡᵐⁱˣ(C.ntime, C.ntau, C.ndim1, C.ndim2, v)
end

"""
    Gˡᵐⁱˣ(C::Cn)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gˡᵐⁱˣ(C::Cn)
    Gˡᵐⁱˣ(C.ntime, C.ntau, C.ndim1, C.ndim2, zero(C64))
end

#=
### *Gˡᵐⁱˣ* : *Properties*
=#

"""
    getdims(lmix::Gˡᵐⁱˣ{T})

Return the dimensional parameters of contour function.

See also: [`Gˡᵐⁱˣ`](@ref).
"""
function getdims(lmix::Gˡᵐⁱˣ{T}) where {T}
    return (lmix.ndim1, lmix.ndim2)
end

"""
    getsize(lmix::Gˡᵐⁱˣ{T})

Return the size of contour function.

See also: [`Gˡᵐⁱˣ`](@ref).
"""
function getsize(lmix::Gˡᵐⁱˣ{T}) where {T}
    return (lmix.ntime, lmix.ntau)
end

"""
    equaldims(lmix::Gˡᵐⁱˣ{T})

Return whether the dimensional parameters are equal.

See also: [`Gˡᵐⁱˣ`](@ref).
"""
function equaldims(lmix::Gˡᵐⁱˣ{T}) where {T}
    return lmix.ndim1 == lmix.ndim2
end

"""
    iscompatible(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T})

Judge whether two `Gˡᵐⁱˣ` objects are compatible.
"""
function iscompatible(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T}) where {T}
    getsize(lmix1) == getsize(lmix2) &&
    getdims(lmix1) == getdims(lmix2)
end

"""
    iscompatible(C::Cn, lmix::Gˡᵐⁱˣ{T})

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `Gˡᵐⁱˣ{T}` object).
"""
function iscompatible(C::Cn, lmix::Gˡᵐⁱˣ{T}) where {T}
    C.ntime, C.ntau == getsize(lmix) &&
    getdims(C) == getdims(lmix)
end

"""
    iscompatible(lmix::Gˡᵐⁱˣ{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `Gˡᵐⁱˣ{T}` object).
"""
iscompatible(lmix::Gˡᵐⁱˣ{T}, C::Cn) where {T} = iscompatible(C, lmix)

"""
    distance(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T}, tstp::I64)

Calculate distance between two `Gˡᵐⁱˣ` objects at given time step `tstp`.
"""
function distance(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T}, tstp::I64) where {T}
    # Sanity check
    @assert 1 ≤ tstp ≤ lmix1.ntime

    err = 0
    #
    for i = 1:lmix1.ntau
        err = err + abs(sum(lmix1.data[tstp,i] - lmix2.data[tstp,i]))
    end
    #
    return err
end

#=
### *Gˡᵐⁱˣ* : *Indexing*
=#

"""
    Base.getindex(lmix::Gˡᵐⁱˣ{T}, i::I64, j::I64)

Visit the element stored in `Gˡᵐⁱˣ` object.
"""
function Base.getindex(lmix::Gˡᵐⁱˣ{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ lmix.ntime
    @assert 1 ≤ j ≤ lmix.ntau

    # Return G^{⌉}(tᵢ, τⱼ)
    lmix.data[i,j]
end

"""
    Base.setindex!(lmix::Gˡᵐⁱˣ{T}, x::Element{T}, i::I64, j::I64)

Setup the element in `Gˡᵐⁱˣ` object.
"""
function Base.setindex!(lmix::Gˡᵐⁱˣ{T}, x::Element{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(lmix)
    @assert 1 ≤ i ≤ lmix.ntime
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ, τⱼ) = x
    lmix.data[i,j] = copy(x)
end

"""
    Base.setindex!(lmix::Gˡᵐⁱˣ{T}, v::T, i::I64, j::I64)

Setup the element in `Gˡᵐⁱˣ` object.
"""
function Base.setindex!(lmix::Gˡᵐⁱˣ{T}, v::T, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ lmix.ntime
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ, τⱼ) .= v
    fill!(lmix.data[i,j], v)
end

#=
### *Gˡᵐⁱˣ* : *Operations*
=#

"""
    memset!(lmix::Gˡᵐⁱˣ{T}, x)

Reset all the matrix elements of `lmix` to `x`. `x` should be a
scalar number.
"""
function memset!(lmix::Gˡᵐⁱˣ{T}, x) where {T}
    cx = convert(T, x)
    for i=1:lmix.ntau
        for j=1:lmix.ntime
            fill!(lmix.data[j,i], cx)
        end
    end
end

"""
    memset!(lmix::Gˡᵐⁱˣ{T}, tstp::I64, x)

Reset the matrix elements of `lmix` at given time step `tstp` to `x`. `x`
should be a scalar number.
"""
function memset!(lmix::Gˡᵐⁱˣ{T}, tstp::I64, x) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    cx = convert(T, x)
    for i=1:lmix.ntau
        fill!(lmix.data[tstp,i], cx)
    end
end

"""
    zeros!(lmix::Gˡᵐⁱˣ{T})

Reset all the matrix elements of `lmix` to `zero`.
"""
zeros!(lmix::Gˡᵐⁱˣ{T}) where {T} = memset!(lmix, zero(T))

"""
    zeros!(lmix::Gˡᵐⁱˣ{T}, tstp::I64)

Reset the matrix elements of `lmix` at given time step `tstp` to `zero`.
"""
zeros!(lmix::Gˡᵐⁱˣ{T}, tstp::I64) where {T} = memset!(lmix, tstp, zero(T))

"""
    memcpy!(src::Gˡᵐⁱˣ{T}, dst::Gˡᵐⁱˣ{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::Gˡᵐⁱˣ{T}, dst::Gˡᵐⁱˣ{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::Gˡᵐⁱˣ{T}, dst::Gˡᵐⁱˣ{T}, tstp::I64)

Copy some matrix elements from `src` to `dst`. Only the matrix elements
at given time step `tstp` are copied.
"""
function memcpy!(src::Gˡᵐⁱˣ{T}, dst::Gˡᵐⁱˣ{T}, tstp::I64) where {T}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    for i=1:src.ntau
        dst.data[tstp,i] = copy(src.data[tstp,i])
    end
end

"""
    incr!(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T}, tstp::I64, α::T)

Add a `Gˡᵐⁱˣ` with given weight (`α`) at given time step `tstp` to
another `Gˡᵐⁱˣ`.
"""
function incr!(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T}, tstp::I64, α::T) where {T}
    @assert iscompatible(lmix1, lmix2)
    @assert 1 ≤ tstp ≤ lmix2.ntime
    for i = 1:lmix2.ntau
        @. lmix1.data[tstp,i] = lmix1.data[tstp,i] + lmix2.data[tstp,i] * α
    end
end

"""
    smul!(lmix::Gˡᵐⁱˣ{T}, tstp::I64, α::T)

Multiply a `Gˡᵐⁱˣ` with given weight (`α`) at given time
step `tstp`.
"""
function smul!(lmix::Gˡᵐⁱˣ{T}, tstp::I64, α::T) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    for i = 1:lmix.ntau
        @. lmix.data[tstp,i] = lmix.data[tstp,i] * α
    end
end

"""
    smul!(x::Element{T}, lmix::Gˡᵐⁱˣ{T}, tstp::I64)

Left multiply a `Gˡᵐⁱˣ` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(x::Element{T}, lmix::Gˡᵐⁱˣ{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    for i = 1:lmix.ntau
        lmix.data[tstp,i] = x * lmix.data[tstp,i]
    end
end

"""
    smul!(lmix::Gˡᵐⁱˣ{T}, x::Element{T}, tstp::I64)

Right multiply a `Gˡᵐⁱˣ` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(lmix::Gˡᵐⁱˣ{T}, x::Element{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    for i = 1:lmix.ntau
        lmix.data[tstp,i] = lmix.data[tstp,i] * x
    end
end

#=
### *Gˡᵐⁱˣ* : *Traits*
=#

"""
    Base.:+(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T})

Operation `+` for two `Gˡᵐⁱˣ` objects.
"""
function Base.:+(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T}) where {T}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    Gˡᵐⁱˣ(lmix1.type, lmix1.ntime, lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data + lmix2.data)
end

"""
    Base.:-(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T})

Operation `-` for two `Gˡᵐⁱˣ` objects.
"""
function Base.:-(lmix1::Gˡᵐⁱˣ{T}, lmix2::Gˡᵐⁱˣ{T}) where {T}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    Gˡᵐⁱˣ(lmix1.type, lmix1.ntime, lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data - lmix2.data)
end

"""
    Base.:*(lmix::Gˡᵐⁱˣ{T}, x)

Operation `*` for a `Gˡᵐⁱˣ` object and a scalar value.
"""
function Base.:*(lmix::Gˡᵐⁱˣ{T}, x) where {T}
    cx = convert(T, x)
    Gˡᵐⁱˣ(lmix.type, lmix.ntime, lmix.ntau, lmix.ndim1, lmix.ndim2, lmix.data * cx)
end

"""
    Base.:*(x, lmix::Gˡᵐⁱˣ{T})

Operation `*` for a scalar value and a `Gˡᵐⁱˣ` object.
"""
Base.:*(x, lmix::Gˡᵐⁱˣ{T}) where {T} = Base.:*(lmix, x)

#=
*Remarks: Lesser Green's Function*

The lesser component of contour Green's function reads

```math
\begin{equation}
G^{<}(t,t') = \mp i \langle c^{\dagger}(t') c(t) \rangle,
\end{equation}
```

where ``t,\ t' \in \mathcal{C}_1 \cup \mathcal{C}_2``. We choose the
upper (lower) sign if the operators ``c`` and ``c^{\dagger}`` are
bosonic (fermionic). Its hermitian conjugate yields

```math
\begin{equation}
G^{<}(t,t')^{*} = -G^{<}(t',t).
\end{equation}
```

The lesser component is related to the retarded, advanced, and Keldysh
Green's functions via

```math
\begin{equation}
G^{<} = \frac{1}{2}(G^{K} - G^{R} + G^{A}).
\end{equation}
```
=#

#=
### *Gˡᵉˢˢ* : *Struct*
=#

"""
    Gˡᵉˢˢ{T}

Lesser component (``G^{<}``) of contour Green's function. We usually
call this component `less`.

See also: [`Gᵐᵃᵗ`](@ref), [`Gʳᵉᵗ`](@ref), [`Gˡᵐⁱˣ`](@ref).
"""
mutable struct Gˡᵉˢˢ{T} <: CnAbstractMatrix{T}
    type  :: String
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *Gˡᵉˢˢ* : *Constructors*
=#

"""
    Gˡᵉˢˢ(ntime::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Gˡᵉˢˢ(ntime::I64, ndim1::I64, ndim2::I64, v::T) where {T}
    # Sanity check
    @assert ntime ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create Element{T}
    element = fill(v, ndim1, ndim2)

    # Create MatArray{T}, whose size is indeed (ntime, ntime).
    data = MatArray{T}(undef, ntime, ntime)
    for i = 1:ntime
        for j = 1:ntime
            data[j,i] = copy(element)
        end
    end

    # Call the default constructor
    Gˡᵉˢˢ("less", ntime, ndim1, ndim2, data)
end

"""
    Gˡᵉˢˢ(ntime::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gˡᵉˢˢ(ntime::I64, ndim1::I64, ndim2::I64)
    Gˡᵉˢˢ(ntime, ndim1, ndim2, zero(C64))
end

"""
    Gˡᵉˢˢ(ntime::I64, ndim1::I64)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gˡᵉˢˢ(ntime::I64, ndim1::I64)
    Gˡᵉˢˢ(ntime, ndim1, ndim1, zero(C64))
end

"""
    Gˡᵉˢˢ(ntime::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Gˡᵉˢˢ(ntime::I64, x::Element{T}) where {T}
    # Sanity check
    @assert ntime ≥ 2

    ndim1, ndim2 = size(x)
    data = MatArray{T}(undef, ntime, ntime)
    for i = 1:ntime
        for j = 1:ntime
            data[j,i] = copy(x)
        end
    end

    # Call the default constructor
    Gˡᵉˢˢ("less", ntime, ndim1, ndim2, data)
end

"""
    Gˡᵉˢˢ(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function Gˡᵉˢˢ(C::Cn, x::Element{T}) where {T}
    # Sanity check
    @assert getdims(C) == size(x)

    # Create MatArray{T}, whose size is indeed (ntime, ntime).
    data = MatArray{T}(undef, C.ntime, C.ntime)
    for i = 1:C.ntime
        for j = 1:C.ntime
            data[j,i] = copy(x)
        end
    end

    # Call the default constructor
    Gˡᵉˢˢ("less", C.ntime, C.ndim1, C.ndim2, data)
end

"""
    Gˡᵉˢˢ(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function Gˡᵉˢˢ(C::Cn, v::T) where {T}
    Gˡᵉˢˢ(C.ntime, C.ndim1, C.ndim2, v)
end

"""
    Gˡᵉˢˢ(C::Cn)

Constructor. All the matrix elements are set to be complex zero.
"""
function Gˡᵉˢˢ(C::Cn)
    Gˡᵉˢˢ(C.ntime, C.ndim1, C.ndim2, zero(C64))
end

#=
### *Gˡᵉˢˢ* : *Properties*
=#

"""
    getdims(less::Gˡᵉˢˢ{T})

Return the dimensional parameters of contour function.

See also: [`Gˡᵉˢˢ`](@ref).
"""
function getdims(less::Gˡᵉˢˢ{T}) where {T}
    return (less.ndim1, less.ndim2)
end

"""
    getsize(less::Gˡᵉˢˢ{T})

Return the size of contour function.

See also: [`Gˡᵉˢˢ`](@ref).
"""
function getsize(less::Gˡᵉˢˢ{T}) where {T}
    return less.ntime
end

"""
    equaldims(less::Gˡᵉˢˢ{T})

Return whether the dimensional parameters are equal.

See also: [`Gˡᵉˢˢ`](@ref).
"""
function equaldims(less::Gˡᵉˢˢ{T}) where {T}
    return less.ndim1 == less.ndim2
end

"""
    iscompatible(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T})

Judge whether two `Gˡᵉˢˢ` objects are compatible.
"""
function iscompatible(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T}) where {T}
    getsize(less1) == getsize(less2) &&
    getdims(less1) == getdims(less2)
end

"""
    iscompatible(C::Cn, less::Gˡᵉˢˢ{T})

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `Gˡᵉˢˢ{T}` object).
"""
function iscompatible(C::Cn, less::Gˡᵉˢˢ{T}) where {T}
    C.ntime == getsize(less) &&
    getdims(C) == getdims(less)
end

"""
    iscompatible(less::Gˡᵉˢˢ{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `Gˡᵉˢˢ{T}` object).
"""
iscompatible(less::Gˡᵉˢˢ{T}, C::Cn) where {T} = iscompatible(C, less)

"""
    distance(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T}, tstp::I64)

Calculate distance between two `Gˡᵉˢˢ` objects at given time step `tstp`.
"""
function distance(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T}, tstp::I64) where {T}
    # Sanity check
    @assert 1 ≤ tstp ≤ less1.ntime

    err = 0
    #
    for i = 1:tstp
        err = err + abs(sum(less1.data[i,tstp] - less2.data[i,tstp]))
    end
    #
    return err
end

#=
### *Gˡᵉˢˢ* : *Indexing*
=#

#=
*Remarks* :

Here we apply the following hermitian conjugate relation:

```math
\begin{equation}
G^{<}(t,t') = -G^{<}(t',t)^{*}
\end{equation}
```

See [`NESSi`] Eq.~(18a) for more details.
=#

"""
    Base.getindex(less::Gˡᵉˢˢ{T}, i::I64, j::I64)

Visit the element stored in `Gˡᵉˢˢ` object.
"""
function Base.getindex(less::Gˡᵉˢˢ{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ less.ntime
    @assert 1 ≤ j ≤ less.ntime

    # Return G^{<}(tᵢ, tⱼ)
    if i ≤ j
        less.data[i,j]
    else
        -less.data'[i,j]
    end
end

"""
    Base.setindex!(less::Gˡᵉˢˢ{T}, x::Element{T}, i::I64, j::I64)

Setup the element in `Gˡᵉˢˢ` object.
"""
function Base.setindex!(less::Gˡᵉˢˢ{T}, x::Element{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(less)
    @assert 1 ≤ i ≤ less.ntime
    @assert 1 ≤ j ≤ less.ntime

    # G^{<}(tᵢ, tⱼ) = x
    less.data[i,j] = copy(x)
end

"""
    Base.setindex!(less::Gˡᵉˢˢ{T}, v::T, i::I64, j::I64)

Setup the element in `Gˡᵉˢˢ` object.
"""
function Base.setindex!(less::Gˡᵉˢˢ{T}, v::T, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ less.ntime
    @assert 1 ≤ j ≤ less.ntime

    # G^{<}(tᵢ, tⱼ) .= v
    fill!(less.data[i,j], v)
end

#=
### *Gˡᵉˢˢ* : *Operations*
=#

"""
    memset!(less::Gˡᵉˢˢ{T}, x)

Reset all the matrix elements of `less` to `x`. `x` should be a
scalar number.
"""
function memset!(less::Gˡᵉˢˢ{T}, x) where {T}
    cx = convert(T, x)
    for i=1:less.ntime
        for j=1:less.ntime
            fill!(less.data[j,i], cx)
        end
    end
end

"""
    memset!(less::Gˡᵉˢˢ{T}, tstp::I64, x)

Reset the matrix elements of `less` at given time step `tstp` (and at all
`t` where `t < tstp`) to `x`. `x` should be a scalar number.
"""
function memset!(less::Gˡᵉˢˢ{T}, tstp::I64, x) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    cx = convert(T, x)
    for i=1:tstp
        fill!(less.data[i,tstp], cx)
    end
end

"""
    zeros!(less::Gˡᵉˢˢ{T})

Reset all the matrix elements of `less` to `zero`.
"""
zeros!(less::Gˡᵉˢˢ{T}) where {T} = memset!(less, zero(T))

"""
    zeros!(less::Gˡᵉˢˢ{T}, tstp::I64)

Reset the matrix elements of `less` at given time step `tstp` (and at all
`t` where `t < tstp`) to `zero`.
"""
zeros!(less::Gˡᵉˢˢ{T}, tstp::I64) where {T} = memset!(less, tstp, zero(T))

"""
    memcpy!(src::Gˡᵉˢˢ{T}, dst::Gˡᵉˢˢ{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::Gˡᵉˢˢ{T}, dst::Gˡᵉˢˢ{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::Gˡᵉˢˢ{T}, dst::Gˡᵉˢˢ{T}, tstp::I64)

Copy some matrix elements from `src` to `dst`. Only the matrix elements
at given time step `tstp` (and at all `t` where `t < tstp`) are copied.
"""
function memcpy!(src::Gˡᵉˢˢ{T}, dst::Gˡᵉˢˢ{T}, tstp::I64) where {T}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    for i=1:tstp
        dst.data[i,tstp] = copy(src.data[i,tstp])
    end
end

"""
    incr!(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T}, tstp::I64, α::T)

Add a `Gˡᵉˢˢ` with given weight (`α`) at given time step `tstp` (and at
all `t` where `t < tstp`) to another `Gˡᵉˢˢ`.
"""
function incr!(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T}, tstp::I64, α::T) where {T}
    @assert iscompatible(less1, less2)
    @assert 1 ≤ tstp ≤ less2.ntime
    for i = 1:tstp
        @. less1.data[i,tstp] = less1.data[i,tstp] + less2.data[i,tstp] * α
    end
end

"""
    smul!(less::Gˡᵉˢˢ{T}, tstp::I64, α::T)

Multiply a `Gˡᵉˢˢ` with given weight (`α`) at given time step `tstp` (and
at all `t` where `t < tstp`).
"""
function smul!(less::Gˡᵉˢˢ{T}, tstp::I64, α::T) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    for i = 1:tstp
        @. less.data[i,tstp] = less.data[i,tstp] * α
    end
end

"""
    smul!(x::Cf{T}, less::Gˡᵉˢˢ{T}, tstp::I64)

Left multiply a `Gˡᵉˢˢ` with given weight (`x`) at given time step `tstp`
(and at all `t` where `t < tstp`).
"""
function smul!(x::Cf{T}, less::Gˡᵉˢˢ{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    for i = 1:tstp
        less.data[i,tstp] = x[i] * less.data[i,tstp]
    end
end

"""
    smul!(less::Gˡᵉˢˢ{T}, x::Element{T}, tstp::I64)

Right multiply a `Gˡᵉˢˢ` with given weight (`x`) at given time step `tstp`
(and at all `t` where `t < tstp`).
"""
function smul!(less::Gˡᵉˢˢ{T}, x::Element{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    for i = 1:tstp
        less.data[i,tstp] = less.data[i,tstp] * x
    end
end

#=
### *Gˡᵉˢˢ* : *Traits*
=#

"""
    Base.:+(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T})

Operation `+` for two `Gˡᵉˢˢ` objects.
"""
function Base.:+(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T}) where {T}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    Gˡᵉˢˢ(less1.type, less1.ntime, less1.ndim1, less1.ndim2, less1.data + less2.data)
end

"""
    Base.:-(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T})

Operation `-` for two `Gˡᵉˢˢ` objects.
"""
function Base.:-(less1::Gˡᵉˢˢ{T}, less2::Gˡᵉˢˢ{T}) where {T}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    Gˡᵉˢˢ(less1.type, less1.ntime, less1.ndim1, less1.ndim2, less1.data - less2.data)
end

"""
    Base.:*(less::Gˡᵉˢˢ{T}, x)

Operation `*` for a `Gˡᵉˢˢ` object and a scalar value.
"""
function Base.:*(less::Gˡᵉˢˢ{T}, x) where {T}
    cx = convert(T, x)
    Gˡᵉˢˢ(less.type, less.ntime, less.ndim1, less.ndim2, less.data * cx)
end

"""
    Base.:*(x, less::Gˡᵉˢˢ{T})

Operation `*` for a scalar value and a `Gˡᵉˢˢ` object.
"""
Base.:*(x, less::Gˡᵉˢˢ{T}) where {T} = Base.:*(less, x)

#=
### *Gᵐᵃᵗᵐ* : *Struct*
=#

"""
    Gᵐᵃᵗᵐ{T}

Matsubara component (``G^M``) of contour Green's function. It is designed
for ``\tau < 0`` case. It is not an independent component. It can be
inferred or deduced from the `Gᵐᵃᵗ{T}` struct. We usually call this
component `matm`.

See also: [`Gʳᵉᵗ`](@ref), [`Gˡᵐⁱˣ`](@ref), [`Gˡᵉˢˢ`](@ref).
"""
mutable struct Gᵐᵃᵗᵐ{T} <: CnAbstractMatrix{T}
    type  :: String
    sign  :: I64 # Used to distinguish fermions and bosons
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataM :: Ref{Gᵐᵃᵗ{T}}
end

#=
### *Gᵐᵃᵗᵐ* : *Constructors*
=#

"""
    Gᵐᵃᵗᵐ(sign::I64, mat::Gᵐᵃᵗ{T})

Constructor. Note that the `matm` component is not independent. We use
the `mat` component to initialize it.
"""
function Gᵐᵃᵗᵐ(sign::I64, mat::Gᵐᵃᵗ{T}) where {T}
    # Sanity check
    @assert sign in (BOSE, FERMI)

    # Setup properties
    # Extract parameters from `mat`
    ntau = mat.ntau
    ndim1 = mat.ndim1
    ndim2 = mat.ndim2
    #
    # We don't allocate memory for `dataM` directly, but let it point to
    # the `mat` object.
    dataM = Ref(mat)

    # Call the default constructor
    Gᵐᵃᵗᵐ("matm", sign, ntau, ndim1, ndim2, dataM)
end

#=
### *Gᵐᵃᵗᵐ* : *Indexing*
=#

"""
    Base.getindex(matm::Gᵐᵃᵗᵐ{T}, ind::I64)

Visit the element stored in `Gᵐᵃᵗᵐ` object.
"""
function Base.getindex(matm::Gᵐᵃᵗᵐ{T}, ind::I64) where {T}
    # Sanity check
    @assert 1 ≤ ind ≤ matm.ntau

    # Return G^{M}(τᵢ < 0)
    matm.dataM[][matm.ntau - ind + 1] * matm.sign
end