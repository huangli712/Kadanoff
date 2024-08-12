#
# Project : Lavender
# Source  : types.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/08/12
#

#=
### *Abstract Types*
=#

#=
*Remarks* :

We need a few abstract types to build the type systems.These abstract
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
*Kadanoff-Baym Contour* :

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

*Contour-ordered Green's Functions* :

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
    Cn(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64, tmax::F64, beta::F64)

Constructor. Create a general 𝐿-shape `Kadanoff-Baym` contour.
"""
function Cn(ntime::I64, ntau::I64,
            ndim1::I64, ndim2::I64,
            tmax::F64, beta::F64)
    # Sanity check
    @assert ntime ≥ 2
    @assert ntau ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1
    @assert tmax > 0.0
    @assert beta > 0.0

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
*Contour-based Functions* :

It is a general matrix-valued function defined at the `Kadanoff-Baym`
contour:

```math
\begin{equation}
\mathcal{F} = f(t),
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

Constructor. All the matrix elements are set to be `CZERO`.
"""
function Cf(ntime::I64, ndim1::I64, ndim2::I64)
    Cf(ntime, ndim1, ndim2, CZERO)
end

"""
    Cf(ntime::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function Cf(ntime::I64, ndim1::I64)
    Cf(ntime, ndim1, ndim1, CZERO)
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

Constructor. All the matrix elements are set to be `CZERO`.
"""
function Cf(C::Cn)
    Cf(C.ntime, C.ndim1, C.ndim2, CZERO)
end

#=
### *Cf* : *Properties*
=#

"""
    getdims(cff::Cf{T})

Return the dimensional parameters of contour function.

See also: [`Cf`](@ref).
"""
function getdims(cff::Cf{T}) where {T}
    return (cff.ndim1, cff.ndim2)
end

"""
    getsize(cff::Cf{T})

Return the nominal size of contour function, i.e `ntime`. Actually, the
real size of contour function should be `ntime + 1`.

See also: [`Cf`](@ref).
"""
function getsize(cff::Cf{T}) where {T}
    return cff.ntime
end

"""
    equaldims(cff::Cf{T})

Return whether the dimensional parameters are equal.

See also: [`Cf`](@ref).
"""
function equaldims(cff::Cf{T}) where {T}
    return cff.ndim1 == cff.ndim2
end

"""
    iscompatible(cff1::Cf{T}, cff2::Cf{T})

Judge whether two `Cf` objects are compatible.
"""
function iscompatible(cff1::Cf{T}, cff2::Cf{T}) where {T}
    getsize(cff1) == getsize(cff2) &&
    getdims(cff1) == getdims(cff2)
end

"""
    iscompatible(C::Cn, cff::Cf{T})

Judge whether `C` (which is a `Cn` object) is compatible with `cff`
(which is a `Cf{T}` object).
"""
function iscompatible(C::Cn, cff::Cf{T}) where {T}
    C.ntime == getsize(cff) &&
    getdims(C) == getdims(cff)
end

"""
    iscompatible(cff::Cf{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `cff`
(which is a `Cf{T}` object).
"""
iscompatible(cff::Cf{T}, C::Cn) where {T} = iscompatible(C, cff)

#=
### *Cf* : *Indexing*
=#

"""
    Base.getindex(cff::Cf{T}, i::I64)

Visit the element stored in `Cf` object. If `i = 0`, it returns
the element at Matsubara axis. On the other hand, if `it > 0`, it will
return elements at real time axis.
"""
function Base.getindex(cff::Cf{T}, i::I64) where {T}
    # Sanity check
    @assert 0 ≤ i ≤ cff.ntime

    # Return 𝑓(𝑡ᵢ)
    if i == 0 # Matsubara axis
        cff.data[end]
    else # Real time axis
        cff.data[i]
    end
end

"""
    Base.setindex!(cff::Cf{T}, x::Element{T}, i::I64)

Setup the element in `Cf` object. If `i = 0`, it will setup the
element at Matsubara axis to `x`. On the other hand, if `it > 0`, it
will setup elements at real time axis.
"""
function Base.setindex!(cff::Cf{T}, x::Element{T}, i::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(cff)
    @assert 0 ≤ i ≤ cff.ntime

    # 𝑓(𝑡ᵢ) = x
    if i == 0 # Matsubara axis
        cff.data[end] = copy(x)
    else # Real time axis
        cff.data[i] = copy(x)
    end
end

"""
    Base.setindex!(cff::Cf{T}, v::T, i::I64)

Setup the element in `Cf` object. If `i = 0`, it will setup the
element at Matsubara axis to `v`. On the other hand, if `it > 0`, it
will setup elements at real time axis. Here, `v` should be a scalar
number.
"""
function Base.setindex!(cff::Cf{T}, v::T, i::I64) where {T}
    # Sanity check
    @assert 0 ≤ i ≤ cff.ntime

    # 𝑓(𝑡ᵢ) .= v
    if i == 0 # Matsubara axis
        fill!(cff.data[end], v)
    else # Real time axis
        fill!(cff.data[i], v)
    end
end

#=
### *Cf* : *Operations*
=#

"""
    memset!(cff::Cf{T}, x)

Reset all the matrix elements of `cff` to `x`. `x` should be a
scalar number.
"""
function memset!(cff::Cf{T}, x) where {T}
    cx = convert(T, x)
    for i = 1:cff.ntime + 1
        fill!(cff.data[i], cx)
    end
end

"""
    zeros!(cff::Cf{T})

Reset all the matrix elements of `cff` to `ZERO`.
"""
zeros!(cff::Cf{T}) where {T} = memset!(cff, zero(T))

"""
    memcpy!(src::Cf{T}, dst::Cf{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::Cf{T}, dst::Cf{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    incr!(cff1::Cf{T}, cff2::Cf{T}, alpha::T)

Add a `Cf` with given weight (`alpha`) to another `Cf`. Finally,
`cff1` will be changed.
"""
function incr!(cff1::Cf{T}, cff2::Cf{T}, alpha::T) where {T}
    @assert iscompatible(cff1, cff2)
    for i = 1:cff1.ntime + 1
        @. cff1.data[i] = cff1.data[i] + cff2.data[i] * alpha
    end
end

"""
    smul!(cff::Cf{T}, alpha::T)

Multiply a `Cf` with given weight (`alpha`).
"""
function smul!(cff::Cf{T}, alpha::T) where {T}
    for i = 1:cff.ntime + 1
        @. cff.data[i] = cff.data[i] * alpha
    end
end

"""
    smul!(x::Element{T}, cff::Cf{T})

Left multiply a `Cf` with given weight (`x`).
"""
function smul!(x::Element{T}, cff::Cf{T}) where {T}
    for i = 1:cff.ntime + 1
        cff.data[i] = x * cff.data[i]
    end
end

"""
    smul!(cff::Cf{T}, x::Element{T})

Right multiply a `Cf` with given weight (`x`).
"""
function smul!(cff::Cf{T}, x::Element{T}) where {T}
    for i = 1:cff.ntime + 1
        cff.data[i] = cff.data[i] * x
    end
end

#=
### *Cf* : *Traits*
=#

"""
    Base.:+(cff1::Cf{T}, cff2::Cf{T})

Operation `+` for two `Cf` objects.
"""
function Base.:+(cff1::Cf{T}, cff2::Cf{T}) where {T}
    # Sanity check
    @assert getsize(cff1) == getsize(cff2)
    @assert getdims(cff1) == getdims(cff2)

    Cf(cff1.ntime, cff1.ndim1, cff1.ndim2, cff1.data + cff2.data)
end

"""
    Base.:-(cff1::Cf{T}, cff2::Cf{T})

Operation `-` for two `Cf` objects.
"""
function Base.:-(cff1::Cf{T}, cff2::Cf{T}) where {T}
    # Sanity check
    @assert getsize(cff1) == getsize(cff2)
    @assert getdims(cff1) == getdims(cff2)

    Cf(cff1.ntime, cff1.ndim1, cff1.ndim2, cff1.data - cff2.data)
end

"""
    Base.:*(cff::Cf{T}, x)

Operation `*` for a `Cf` object and a scalar value.
"""
function Base.:*(cff::Cf{T}, x) where {T}
    cx = convert(T, x)
    Cf(cff.ntime, cff.ndim1, cff.ndim2, cff.data * cx)
end

"""
    Base.:*(x, cff::Cf{T})

Operation `*` for a scalar value and a `Cf` object.
"""
Base.:*(x, cff::Cf{T}) where {T} = Base.:*(cff, x)

#=
*Matsubara Green's Function* :

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
### *𝔾ᵐᵃᵗ* : *Struct*
=#

"""
    𝔾ᵐᵃᵗ{T}

Matsubara component (``G^M``) of contour Green's function. We usually
call this component `mat`. Here we just assume ``\tau ≥ 0``. While for
``\tau < 0``, please turn to the `𝔾ᵐᵃᵗᵐ{T}` struct.

See also: [`𝔾ʳᵉᵗ`](@ref), [`𝔾ˡᵐⁱˣ`](@ref), [`𝔾ˡᵉˢˢ`](@ref).
"""
mutable struct 𝔾ᵐᵃᵗ{T} <: CnAbstractMatrix{T}
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *𝔾ᵐᵃᵗ* : *Constructors*
=#

"""
    𝔾ᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function 𝔾ᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64, v::T) where {T}
    # Sanity check
    @assert ntau ≥ 2
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
    𝔾ᵐᵃᵗ(ntau, ndim1, ndim2, data)
end

"""
    𝔾ᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64)
    𝔾ᵐᵃᵗ(ntau, ndim1, ndim2, CZERO)
end

"""
    𝔾ᵐᵃᵗ(ntau::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ᵐᵃᵗ(ntau::I64, ndim1::I64)
    𝔾ᵐᵃᵗ(ntau, ndim1, ndim1, CZERO)
end

"""
    𝔾ᵐᵃᵗ(ntau::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function 𝔾ᵐᵃᵗ(ntau::I64, x::Element{T}) where {T}
    # Sanity check
    @assert ntau ≥ 2

    ndim1, ndim2 = size(x)
    data = MatArray{T}(undef, ntau, 1)
    for i=1:ntau
        data[i,1] = copy(x)
    end

    # Call the default constructor
    𝔾ᵐᵃᵗ(ntau, ndim1, ndim2, data)
end

"""
    𝔾ᵐᵃᵗ(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function 𝔾ᵐᵃᵗ(C::Cn, x::Element{T}) where {T}
    # Sanity check
    @assert getdims(C) == size(x)

    # Create MatArray{T}, whose size is indeed (ntau, 1).
    data = MatArray{T}(undef, C.ntau, 1)
    for i=1:C.ntau
        data[i,1] = copy(x)
    end

    # Call the default constructor
    𝔾ᵐᵃᵗ(C.ntau, C.ndim1, C.ndim2, data)
end

"""
    𝔾ᵐᵃᵗ(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function 𝔾ᵐᵃᵗ(C::Cn, v::T) where {T}
    𝔾ᵐᵃᵗ(C.ntau, C.ndim1, C.ndim2, v)
end

"""
    𝔾ᵐᵃᵗ(C::Cn)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ᵐᵃᵗ(C::Cn)
    𝔾ᵐᵃᵗ(C.ntau, C.ndim1, C.ndim2, CZERO)
end

#=
### *𝔾ᵐᵃᵗ* : *Properties*
=#

"""
    getdims(mat::𝔾ᵐᵃᵗ{T})

Return the dimensional parameters of contour function.

See also: [`𝔾ᵐᵃᵗ`](@ref).
"""
function getdims(mat::𝔾ᵐᵃᵗ{T}) where {T}
    return (mat.ndim1, mat.ndim2)
end

"""
    getsize(mat::𝔾ᵐᵃᵗ{T})

Return the size of contour function. Here, it should be `ntau`.

See also: [`𝔾ᵐᵃᵗ`](@ref).
"""
function getsize(mat::𝔾ᵐᵃᵗ{T}) where {T}
    return mat.ntau
end

"""
    equaldims(mat::𝔾ᵐᵃᵗ{T})

Return whether the dimensional parameters are equal.

See also: [`𝔾ᵐᵃᵗ`](@ref).
"""
function equaldims(mat::𝔾ᵐᵃᵗ{T}) where {T}
    return mat.ndim1 == mat.ndim2
end

"""
    iscompatible(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T})

Judge whether two `𝔾ᵐᵃᵗ` objects are compatible.
"""
function iscompatible(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T}) where {T}
    getsize(mat1) == getsize(mat2) &&
    getdims(mat1) == getdims(mat2)
end

"""
    iscompatible(C::Cn, mat::𝔾ᵐᵃᵗ{T})

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `𝔾ᵐᵃᵗ{T}` object).
"""
function iscompatible(C::Cn, mat::𝔾ᵐᵃᵗ{T}) where {T}
    C.ntau == getsize(mat) &&
    getdims(C) == getdims(mat)
end

"""
    iscompatible(mat::𝔾ᵐᵃᵗ{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `𝔾ᵐᵃᵗ{T}` object).
"""
iscompatible(mat::𝔾ᵐᵃᵗ{T}, C::Cn) where {T} = iscompatible(C, mat)

"""
    distance(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T})

Calculate distance between two `𝔾ᵐᵃᵗ` objects.
"""
function distance(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T}) where {T}
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
### *𝔾ᵐᵃᵗ* : *Indexing*
=#

"""
    Base.getindex(mat::𝔾ᵐᵃᵗ{T}, ind::I64)

Visit the element stored in `𝔾ᵐᵃᵗ` object.
"""
function Base.getindex(mat::𝔾ᵐᵃᵗ{T}, ind::I64) where {T}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # Return G^{M}(τᵢ ≥ 0)
    mat.data[ind,1]
end

"""
    Base.setindex!(mat::𝔾ᵐᵃᵗ{T}, x::Element{T}, ind::I64)

Setup the element in `𝔾ᵐᵃᵗ` object.
"""
function Base.setindex!(mat::𝔾ᵐᵃᵗ{T}, x::Element{T}, ind::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(mat)
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) = x
    mat.data[ind,1] = copy(x)
end

"""
    Base.setindex!(mat::𝔾ᵐᵃᵗ{T}, v::T, ind::I64)

Setup the element in `𝔾ᵐᵃᵗ` object.
"""
function Base.setindex!(mat::𝔾ᵐᵃᵗ{T}, v::T, ind::I64) where {T}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) .= v
    fill!(mat.data[ind,1], v)
end

#=
### *𝔾ᵐᵃᵗ* : *Operations*
=#

"""
    memset!(mat::𝔾ᵐᵃᵗ{T}, x)

Reset all the matrix elements of `mat` to `x`. `x` should be a
scalar number.
"""
function memset!(mat::𝔾ᵐᵃᵗ{T}, x) where {T}
    cx = convert(T, x)
    for i = 1:mat.ntau
        fill!(mat.data[i,1], cx)
    end
end

"""
    zeros!(mat::𝔾ᵐᵃᵗ{T})

Reset all the matrix elements of `mat` to `ZERO`.
"""
zeros!(mat::𝔾ᵐᵃᵗ{T}) where {T} = memset!(mat, zero(T))

"""
    memcpy!(src::𝔾ᵐᵃᵗ{T}, dst::𝔾ᵐᵃᵗ{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::𝔾ᵐᵃᵗ{T}, dst::𝔾ᵐᵃᵗ{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    incr!(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T}, alpha::T)

Add a `𝔾ᵐᵃᵗ` with given weight (`alpha`) to another `𝔾ᵐᵃᵗ`.

```math
G^M_1 ⟶ G^M_1 + α * G^M_2.
```
"""
function incr!(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T}, alpha::T) where {T}
    @assert iscompatible(mat1, mat2)
    for i = 1:mat2.ntau
        @. mat1.data[i,1] = mat1.data[i,1] + mat2.data[i,1] * alpha
    end
end

"""
    smul!(mat::𝔾ᵐᵃᵗ{T}, alpha::T)

Multiply a `𝔾ᵐᵃᵗ` with given weight (`alpha`).

```math
G^M ⟶ α * G^M.
```
"""
function smul!(mat::𝔾ᵐᵃᵗ{T}, alpha::T) where {T}
    for i = 1:mat.ntau
        @. mat.data[i,1] = mat.data[i,1] * alpha
    end
end

"""
    smul!(x::Element{T}, mat::𝔾ᵐᵃᵗ{T})

Left multiply a `𝔾ᵐᵃᵗ` with given weight (`x`), which is actually a
matrix.
"""
function smul!(x::Element{T}, mat::𝔾ᵐᵃᵗ{T}) where {T}
    for i = 1:mat.ntau
        mat.data[i,1] = x * mat.data[i,1]
    end
end

"""
    smul!(mat::𝔾ᵐᵃᵗ{T}, x::Element{T})

Right multiply a `𝔾ᵐᵃᵗ` with given weight (`x`), which is actually a
matrix.
"""
function smul!(mat::𝔾ᵐᵃᵗ{T}, x::Element{T}) where {T}
    for i = 1:mat.ntau
        mat.data[i,1] = mat.data[i,1] * x
    end
end

#=
### *𝔾ᵐᵃᵗ* : *Traits*
=#

"""
    Base.:+(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T})

Operation `+` for two `𝔾ᵐᵃᵗ` objects.
"""
function Base.:+(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T}) where {T}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    𝔾ᵐᵃᵗ(mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data + mat2.data)
end

"""
    Base.:-(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T})

Operation `-` for two `𝔾ᵐᵃᵗ` objects.
"""
function Base.:-(mat1::𝔾ᵐᵃᵗ{T}, mat2::𝔾ᵐᵃᵗ{T}) where {T}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    𝔾ᵐᵃᵗ(mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data - mat2.data)
end

"""
    Base.:*(mat::𝔾ᵐᵃᵗ{T}, x)

Operation `*` for a `𝔾ᵐᵃᵗ` object and a scalar value.
"""
function Base.:*(mat::𝔾ᵐᵃᵗ{T}, x) where {T}
    cx = convert(T, x)
    𝔾ᵐᵃᵗ(mat.ntau, mat.ndim1, mat.ndim2, mat.data * cx)
end

"""
    Base.:*(x, mat::𝔾ᵐᵃᵗ{T})

Operation `*` for a scalar value and a `𝔾ᵐᵃᵗ` object.
"""
Base.:*(x, mat::𝔾ᵐᵃᵗ{T}) where {T} = Base.:*(mat, x)

#=
### *𝔾ᵐᵃᵗᵐ* : *Struct*
=#

"""
    𝔾ᵐᵃᵗᵐ{T}

Matsubara component (``G^M``) of contour Green's function. It is designed
for ``\tau < 0`` case. It is not an independent component. It can be
inferred or deduced from the `𝔾ᵐᵃᵗ{T}` struct. We usually call this
component `matm`.

See also: [`𝔾ʳᵉᵗ`](@ref), [`𝔾ˡᵐⁱˣ`](@ref), [`𝔾ˡᵉˢˢ`](@ref).
"""
mutable struct 𝔾ᵐᵃᵗᵐ{T} <: CnAbstractMatrix{T}
    sign  :: I64 # Used to distinguish fermions and bosons
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataM :: Ref{𝔾ᵐᵃᵗ{T}}
end

#=
### *𝔾ᵐᵃᵗᵐ* : *Constructors*
=#

"""
    𝔾ᵐᵃᵗᵐ(sign::I64, mat::𝔾ᵐᵃᵗ{T})

Constructor. Note that the `matm` component is not independent. We use
the `mat` component to initialize it.
"""
function 𝔾ᵐᵃᵗᵐ(sign::I64, mat::𝔾ᵐᵃᵗ{T}) where {T}
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
    𝔾ᵐᵃᵗᵐ(sign, ntau, ndim1, ndim2, dataM)
end

#=
### *𝔾ᵐᵃᵗᵐ* : *Indexing*
=#

"""
    Base.getindex(matm::𝔾ᵐᵃᵗᵐ{T}, ind::I64)

Visit the element stored in `𝔾ᵐᵃᵗᵐ` object.
"""
function Base.getindex(matm::𝔾ᵐᵃᵗᵐ{T}, ind::I64) where {T}
    # Sanity check
    @assert 1 ≤ ind ≤ matm.ntau

    # Return G^{M}(τᵢ < 0)
    matm.dataM[][matm.ntau - ind + 1] * matm.sign
end

#=
*Retarded Green's Function* :

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
### *𝔾ʳᵉᵗ* : *Struct*
=#

"""
    𝔾ʳᵉᵗ{T}

Retarded component (``G^R``) of contour Green's function.

See also: [`𝔾ᵐᵃᵗ`](@ref), [`𝔾ˡᵐⁱˣ`](@ref), [`𝔾ˡᵉˢˢ`](@ref).
"""
mutable struct 𝔾ʳᵉᵗ{T} <: CnAbstractMatrix{T}
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *𝔾ʳᵉᵗ* : *Constructors*
=#

"""
    𝔾ʳᵉᵗ(ntime::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function 𝔾ʳᵉᵗ(ntime::I64, ndim1::I64, ndim2::I64, v::T) where {T}
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
    𝔾ʳᵉᵗ(ntime, ndim1, ndim2, data)
end

"""
    𝔾ʳᵉᵗ(ntime::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ʳᵉᵗ(ntime::I64, ndim1::I64, ndim2::I64)
    𝔾ʳᵉᵗ(ntime, ndim1, ndim2, CZERO)
end

"""
    𝔾ʳᵉᵗ(ntime::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ʳᵉᵗ(ntime::I64, ndim1::I64)
    𝔾ʳᵉᵗ(ntime, ndim1, ndim1, CZERO)
end

"""
    𝔾ʳᵉᵗ(ntime::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function 𝔾ʳᵉᵗ(ntime::I64, x::Element{T}) where {T}
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
    𝔾ʳᵉᵗ(ntime, ndim1, ndim2, data)
end

"""
    𝔾ʳᵉᵗ(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function 𝔾ʳᵉᵗ(C::Cn, x::Element{T}) where {T}
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
    𝔾ʳᵉᵗ(C.ntime, C.ndim1, C.ndim2, data)
end

"""
    𝔾ʳᵉᵗ(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function 𝔾ʳᵉᵗ(C::Cn, v::T) where {T}
    𝔾ʳᵉᵗ(C.ntime, C.ndim1, C.ndim2, v)
end

"""
    𝔾ʳᵉᵗ(C::Cn)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ʳᵉᵗ(C::Cn)
    𝔾ʳᵉᵗ(C.ntime, C.ndim1, C.ndim2, CZERO)
end

#=
### *𝔾ʳᵉᵗ* : *Properties*
=#

"""
    getdims(ret::𝔾ʳᵉᵗ{T})

Return the dimensional parameters of contour function.

See also: [`𝔾ʳᵉᵗ`](@ref).
"""
function getdims(ret::𝔾ʳᵉᵗ{T}) where {T}
    return (ret.ndim1, ret.ndim2)
end

"""
    getsize(ret::𝔾ʳᵉᵗ{T})

Return the size of contour function.

See also: [`𝔾ʳᵉᵗ`](@ref).
"""
function getsize(ret::𝔾ʳᵉᵗ{T}) where {T}
    return ret.ntime
end

"""
    equaldims(ret::𝔾ʳᵉᵗ{T})

Return whether the dimensional parameters are equal.

See also: [`𝔾ʳᵉᵗ`](@ref).
"""
function equaldims(ret::𝔾ʳᵉᵗ{T}) where {T}
    return ret.ndim1 == ret.ndim2
end

"""
    iscompatible(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T})

Judge whether two `𝔾ʳᵉᵗ` objects are compatible.
"""
function iscompatible(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T}) where {T}
    getsize(ret1) == getsize(ret2) &&
    getdims(ret1) == getdims(ret2)
end

"""
    iscompatible(C::Cn, ret::𝔾ʳᵉᵗ{T})

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `𝔾ʳᵉᵗ{T}` object).
"""
function iscompatible(C::Cn, ret::𝔾ʳᵉᵗ{T}) where {T}
    C.ntime == getsize(ret) &&
    getdims(C) == getdims(ret)
end

"""
    iscompatible(ret::𝔾ʳᵉᵗ{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `𝔾ʳᵉᵗ{T}` object).
"""
iscompatible(ret::𝔾ʳᵉᵗ{T}, C::Cn) where {T} = iscompatible(C, ret)

"""
    distance(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T}, tstp::I64)

Calculate distance between two `𝔾ʳᵉᵗ` objects at given time step `tstp`.
"""
function distance(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T}, tstp::I64) where {T}
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
### *𝔾ʳᵉᵗ* : *Indexing*
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
    Base.getindex(ret::𝔾ʳᵉᵗ{T}, i::I64, j::I64)

Visit the element stored in `𝔾ʳᵉᵗ` object. Here `i` and `j` are indices
for real times.
"""
function Base.getindex(ret::𝔾ʳᵉᵗ{T}, i::I64, j::I64) where {T}
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
    Base.setindex!(ret::𝔾ʳᵉᵗ{T}, x::Element{T}, i::I64, j::I64)

Setup the element in `𝔾ʳᵉᵗ` object.
"""
function Base.setindex!(ret::𝔾ʳᵉᵗ{T}, x::Element{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(ret)
    @assert 1 ≤ i ≤ ret.ntime
    @assert 1 ≤ j ≤ ret.ntime

    # G^{R}(tᵢ, tⱼ) = x
    ret.data[i,j] = copy(x)
end

"""
    Base.setindex!(ret::𝔾ʳᵉᵗ{T}, v::T, i::I64, j::I64)

Setup the element in `𝔾ʳᵉᵗ` object.
"""
function Base.setindex!(ret::𝔾ʳᵉᵗ{T}, v::T, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ ret.ntime
    @assert 1 ≤ j ≤ ret.ntime

    # G^{R}(tᵢ, tⱼ) .= v
    fill!(ret.data[i,j], v)
end

#=
### *𝔾ʳᵉᵗ* : *Operations*
=#

"""
    memset!(ret::𝔾ʳᵉᵗ{T}, x)

Reset all the matrix elements of `ret` to `x`. `x` should be a
scalar number.
"""
function memset!(ret::𝔾ʳᵉᵗ{T}, x) where {T}
    cx = convert(T, x)
    for i=1:ret.ntime
        for j=1:ret.ntime
            fill!(ret.data[j,i], cx)
        end
    end
end

"""
    memset!(ret::𝔾ʳᵉᵗ{T}, tstp::I64, x)

Reset the matrix elements of `ret` at given time step `tstp` to `x`. `x`
should be a scalar number.
"""
function memset!(ret::𝔾ʳᵉᵗ{T}, tstp::I64, x) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    cx = convert(T, x)
    for i=1:tstp
        fill!(ret.data[tstp,i], cx)
    end
end

"""
    zeros!(ret::𝔾ʳᵉᵗ{T})

Reset all the matrix elements of `ret` to `ZERO`.
"""
zeros!(ret::𝔾ʳᵉᵗ{T}) where {T} = memset!(ret, zero(T))

"""
    zeros!(ret::𝔾ʳᵉᵗ{T}, tstp::I64)

Reset the matrix elements of `ret` at given time step `tstp` to `ZERO`.
"""
zeros!(ret::𝔾ʳᵉᵗ{T}, tstp::I64) where {T} = memset!(ret, tstp, zero(T))

"""
    memcpy!(src::𝔾ʳᵉᵗ{T}, dst::𝔾ʳᵉᵗ{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::𝔾ʳᵉᵗ{T}, dst::𝔾ʳᵉᵗ{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::𝔾ʳᵉᵗ{T}, dst::𝔾ʳᵉᵗ{T}, tstp::I64)

Copy some matrix elements from `src` to `dst`. Only the matrix elements
at given time step `tstp` are copied.
"""
function memcpy!(src::𝔾ʳᵉᵗ{T}, dst::𝔾ʳᵉᵗ{T}, tstp::I64) where {T}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    for i=1:tstp
        dst.data[tstp,i] = copy(src.data[tstp,i])
    end
end

"""
    incr!(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T}, tstp::I64, alpha::T)

Add a `𝔾ʳᵉᵗ` with given weight (`alpha`) at given time step `tstp` to
another `𝔾ʳᵉᵗ`.
"""
function incr!(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T}, tstp::I64, alpha::T) where {T}
    @assert iscompatible(ret1, ret2)
    @assert 1 ≤ tstp ≤ ret2.ntime
    for i = 1:tstp
        @. ret1.data[tstp,i] = ret1.data[tstp,i] + ret2.data[tstp,i] * alpha
    end
end

"""
    smul!(ret::𝔾ʳᵉᵗ{T}, tstp::I64, alpha::T)

Multiply a `𝔾ʳᵉᵗ` with given weight (`alpha`) at given time step `tstp`.
"""
function smul!(ret::𝔾ʳᵉᵗ{T}, tstp::I64, alpha::T) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    for i = 1:tstp
        @. ret.data[tstp,i] = ret.data[tstp,i] * alpha
    end
end

"""
    smul!(x::Element{T}, ret::𝔾ʳᵉᵗ{T}, tstp::I64)

Left multiply a `𝔾ʳᵉᵗ` with given weight (`x`) at given time step `tstp`.
"""
function smul!(x::Element{T}, ret::𝔾ʳᵉᵗ{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    for i = 1:tstp
        ret.data[tstp,i] = x * ret.data[tstp,i]
    end
end

"""
    smul!(ret::𝔾ʳᵉᵗ{T}, x::Cf{T}, tstp::I64)

Right multiply a `𝔾ʳᵉᵗ` with given weight (`x`) at given time step `tstp`.
"""
function smul!(ret::𝔾ʳᵉᵗ{T}, x::Cf{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    for i = 1:tstp
        ret.data[tstp,i] = ret.data[tstp,i] * x[i]
    end
end

#=
### *𝔾ʳᵉᵗ* : *Traits*
=#

"""
    Base.:+(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T})

Operation `+` for two `𝔾ʳᵉᵗ` objects.
"""
function Base.:+(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T}) where {T}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    𝔾ʳᵉᵗ(ret1.ntime, ret1.ndim1, ret1.ndim2, ret1.data + ret2.data)
end

"""
    Base.:-(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T})

Operation `-` for two `𝔾ʳᵉᵗ` objects.
"""
function Base.:-(ret1::𝔾ʳᵉᵗ{T}, ret2::𝔾ʳᵉᵗ{T}) where {T}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    𝔾ʳᵉᵗ(ret1.ntime, ret1.ndim1, ret1.ndim2, ret1.data - ret2.data)
end

"""
    Base.:*(ret::𝔾ʳᵉᵗ{T}, x)

Operation `*` for a `𝔾ʳᵉᵗ` object and a scalar value.
"""
function Base.:*(ret::𝔾ʳᵉᵗ{T}, x) where {T}
    cx = convert(T, x)
    𝔾ʳᵉᵗ(ret.ntime, ret.ndim1, ret.ndim2, ret.data * cx)
end

"""
    Base.:*(x, ret::𝔾ʳᵉᵗ{T})

Operation `*` for a scalar value and a `𝔾ʳᵉᵗ` object.
"""
Base.:*(x, ret::𝔾ʳᵉᵗ{T}) where {T} = Base.:*(ret, x)

#=
*Advanced Green's Function* :

The advanced component of contour Green's function reads

```math
\begin{equation}
G^{A}(t,t') =
    i \theta(t'-t) \langle [c(t), c^{\dagger}(t')]_{\mp} \rangle,
\end{equation}
```

Here, ``t``, ``t'`` belong to ``\mathcal{C}_1 ∪ \mathcal{C}_2``,
``\theta(t)`` is a step function, ``[,]_{-(+)}`` denotes an
(anti-)commutator. We choose the -(+) sign if the operators ``c``
and ``c^{\dagger}`` are bosonic (fermionic).
=#

#=
### *𝔾ᵃᵈᵛ* : *Struct*
=#

"""
    𝔾ᵃᵈᵛ{T}

Advanced component (``G^{A}``) of contour Green's function.

Note: currently we do not need this component explicitly. However, for
the sake of completeness, we still define an empty struct for it.

See also: [`𝔾ᵐᵃᵗ`](@ref), [`𝔾ˡᵐⁱˣ`](@ref), [`𝔾ˡᵉˢˢ`](@ref).
"""
mutable struct 𝔾ᵃᵈᵛ{T} <: CnAbstractMatrix{T} end

#=
*Left-mixing Green's Function* :

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
### *𝔾ˡᵐⁱˣ* : *Struct*
=#

"""
    𝔾ˡᵐⁱˣ{T}

Left-mixing component (``G^{⌉}``) of contour Green's function.

See also: [`𝔾ᵐᵃᵗ`](@ref), [`𝔾ʳᵉᵗ`](@ref), [`𝔾ˡᵉˢˢ`](@ref).
"""
mutable struct 𝔾ˡᵐⁱˣ{T} <: CnAbstractMatrix{T}
    ntime :: I64
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *𝔾ˡᵐⁱˣ* : *Constructors*
=#

"""
    𝔾ˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function 𝔾ˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64, v::T) where {T}
    # Sanity check
    @assert ntime ≥ 2
    @assert ntau ≥ 2
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
    𝔾ˡᵐⁱˣ(ntime, ntau, ndim1, ndim2, data)
end

"""
    𝔾ˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64)
    𝔾ˡᵐⁱˣ(ntime, ntau, ndim1, ndim2, CZERO)
end

"""
    𝔾ˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ˡᵐⁱˣ(ntime::I64, ntau::I64, ndim1::I64)
    𝔾ˡᵐⁱˣ(ntime, ntau, ndim1, ndim1, CZERO)
end

"""
    𝔾ˡᵐⁱˣ(ntime::I64, ntau::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function 𝔾ˡᵐⁱˣ(ntime::I64, ntau::I64, x::Element{T}) where {T}
    # Sanity check
    @assert ntime ≥ 2
    @assert ntau ≥ 2

    ndim1, ndim2 = size(x)
    data = MatArray{T}(undef, ntime, ntau)
    for i = 1:ntau
        for j = 1:ntime
            data[j,i] = copy(x)
        end
    end

    # Call the default constructor
    𝔾ˡᵐⁱˣ(ntime, ntau, ndim1, ndim2, data)
end

"""
    𝔾ˡᵐⁱˣ(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function 𝔾ˡᵐⁱˣ(C::Cn, x::Element{T}) where {T}
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
    𝔾ˡᵐⁱˣ(C.ntime, C.ntau, C.ndim1, C.ndim2, data)
end

"""
    𝔾ˡᵐⁱˣ(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function 𝔾ˡᵐⁱˣ(C::Cn, v::T) where {T}
    𝔾ˡᵐⁱˣ(C.ntime, C.ntau, C.ndim1, C.ndim2, v)
end

"""
    𝔾ˡᵐⁱˣ(C::Cn)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ˡᵐⁱˣ(C::Cn)
    𝔾ˡᵐⁱˣ(C.ntime, C.ntau, C.ndim1, C.ndim2, CZERO)
end

#=
### *𝔾ˡᵐⁱˣ* : *Properties*
=#

"""
    getdims(lmix::𝔾ˡᵐⁱˣ{T})

Return the dimensional parameters of contour function.

See also: [`𝔾ˡᵐⁱˣ`](@ref).
"""
function getdims(lmix::𝔾ˡᵐⁱˣ{T}) where {T}
    return (lmix.ndim1, lmix.ndim2)
end

"""
    getsize(lmix::𝔾ˡᵐⁱˣ{T})

Return the size of contour function.

See also: [`𝔾ˡᵐⁱˣ`](@ref).
"""
function getsize(lmix::𝔾ˡᵐⁱˣ{T}) where {T}
    return (lmix.ntime, lmix.ntau)
end

"""
    equaldims(lmix::𝔾ˡᵐⁱˣ{T})

Return whether the dimensional parameters are equal.

See also: [`𝔾ˡᵐⁱˣ`](@ref).
"""
function equaldims(lmix::𝔾ˡᵐⁱˣ{T}) where {T}
    return lmix.ndim1 == lmix.ndim2
end

"""
    iscompatible(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T})

Judge whether two `𝔾ˡᵐⁱˣ` objects are compatible.
"""
function iscompatible(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T}) where {T}
    getsize(lmix1) == getsize(lmix2) &&
    getdims(lmix1) == getdims(lmix2)
end

"""
    iscompatible(C::Cn, lmix::𝔾ˡᵐⁱˣ{T})

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `𝔾ˡᵐⁱˣ{T}` object).
"""
function iscompatible(C::Cn, lmix::𝔾ˡᵐⁱˣ{T}) where {T}
    C.ntime, C.ntau == getsize(lmix) &&
    getdims(C) == getdims(lmix)
end

"""
    iscompatible(lmix::𝔾ˡᵐⁱˣ{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `𝔾ˡᵐⁱˣ{T}` object).
"""
iscompatible(lmix::𝔾ˡᵐⁱˣ{T}, C::Cn) where {T} = iscompatible(C, lmix)

"""
    distance(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T}, tstp::I64)

Calculate distance between two `𝔾ˡᵐⁱˣ` objects at given time step `tstp`.
"""
function distance(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T}, tstp::I64) where {T}
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
### *𝔾ˡᵐⁱˣ* : *Indexing*
=#

"""
    Base.getindex(lmix::𝔾ˡᵐⁱˣ{T}, i::I64, j::I64)

Visit the element stored in `𝔾ˡᵐⁱˣ` object.
"""
function Base.getindex(lmix::𝔾ˡᵐⁱˣ{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ lmix.ntime
    @assert 1 ≤ j ≤ lmix.ntau

    # Return G^{⌉}(tᵢ, τⱼ)
    lmix.data[i,j]
end

"""
    Base.setindex!(lmix::𝔾ˡᵐⁱˣ{T}, x::Element{T}, i::I64, j::I64)

Setup the element in `𝔾ˡᵐⁱˣ` object.
"""
function Base.setindex!(lmix::𝔾ˡᵐⁱˣ{T}, x::Element{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(lmix)
    @assert 1 ≤ i ≤ lmix.ntime
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ, τⱼ) = x
    lmix.data[i,j] = copy(x)
end

"""
    Base.setindex!(lmix::𝔾ˡᵐⁱˣ{T}, v::T, i::I64, j::I64)

Setup the element in `𝔾ˡᵐⁱˣ` object.
"""
function Base.setindex!(lmix::𝔾ˡᵐⁱˣ{T}, v::T, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ lmix.ntime
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ, τⱼ) .= v
    fill!(lmix.data[i,j], v)
end

#=
### *𝔾ˡᵐⁱˣ* : *Operations*
=#

"""
    memset!(lmix::𝔾ˡᵐⁱˣ{T}, x)

Reset all the matrix elements of `lmix` to `x`. `x` should be a
scalar number.
"""
function memset!(lmix::𝔾ˡᵐⁱˣ{T}, x) where {T}
    cx = convert(T, x)
    for i=1:lmix.ntau
        for j=1:lmix.ntime
            fill!(lmix.data[j,i], cx)
        end
    end
end

"""
    memset!(lmix::𝔾ˡᵐⁱˣ{T}, tstp::I64, x)

Reset the matrix elements of `lmix` at given time step `tstp` to `x`. `x`
should be a scalar number.
"""
function memset!(lmix::𝔾ˡᵐⁱˣ{T}, tstp::I64, x) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    cx = convert(T, x)
    for i=1:lmix.ntau
        fill!(lmix.data[tstp,i], cx)
    end
end

"""
    zeros!(lmix::𝔾ˡᵐⁱˣ{T})

Reset all the matrix elements of `lmix` to `ZERO`.
"""
zeros!(lmix::𝔾ˡᵐⁱˣ{T}) where {T} = memset!(lmix, zero(T))

"""
    zeros!(lmix::𝔾ˡᵐⁱˣ{T}, tstp::I64)

Reset the matrix elements of `lmix` at given time step `tstp` to `ZERO`.
"""
zeros!(lmix::𝔾ˡᵐⁱˣ{T}, tstp::I64) where {T} = memset!(lmix, tstp, zero(T))

"""
    memcpy!(src::𝔾ˡᵐⁱˣ{T}, dst::𝔾ˡᵐⁱˣ{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::𝔾ˡᵐⁱˣ{T}, dst::𝔾ˡᵐⁱˣ{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::𝔾ˡᵐⁱˣ{T}, dst::𝔾ˡᵐⁱˣ{T}, tstp::I64)

Copy some matrix elements from `src` to `dst`. Only the matrix elements
at given time step `tstp` are copied.
"""
function memcpy!(src::𝔾ˡᵐⁱˣ{T}, dst::𝔾ˡᵐⁱˣ{T}, tstp::I64) where {T}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    for i=1:src.ntau
        dst.data[tstp,i] = copy(src.data[tstp,i])
    end
end

"""
    incr!(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T}, tstp::I64, alpha::T)

Add a `𝔾ˡᵐⁱˣ` with given weight (`alpha`) at given time step `tstp` to
another `𝔾ˡᵐⁱˣ`.
"""
function incr!(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T}, tstp::I64, alpha::T) where {T}
    @assert iscompatible(lmix1, lmix2)
    @assert 1 ≤ tstp ≤ lmix2.ntime
    for i = 1:lmix2.ntau
        @. lmix1.data[tstp,i] = lmix1.data[tstp,i] + lmix2.data[tstp,i] * alpha
    end
end

"""
    smul!(lmix::𝔾ˡᵐⁱˣ{T}, tstp::I64, alpha::T)

Multiply a `𝔾ˡᵐⁱˣ` with given weight (`alpha`) at given time
step `tstp`.
"""
function smul!(lmix::𝔾ˡᵐⁱˣ{T}, tstp::I64, alpha::T) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    for i = 1:lmix.ntau
        @. lmix.data[tstp,i] = lmix.data[tstp,i] * alpha
    end
end

"""
    smul!(x::Element{T}, lmix::𝔾ˡᵐⁱˣ{T}, tstp::I64)

Left multiply a `𝔾ˡᵐⁱˣ` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(x::Element{T}, lmix::𝔾ˡᵐⁱˣ{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    for i = 1:lmix.ntau
        lmix.data[tstp,i] = x * lmix.data[tstp,i]
    end
end

"""
    smul!(lmix::𝔾ˡᵐⁱˣ{T}, x::Element{T}, tstp::I64)

Right multiply a `𝔾ˡᵐⁱˣ` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(lmix::𝔾ˡᵐⁱˣ{T}, x::Element{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    for i = 1:lmix.ntau
        lmix.data[tstp,i] = lmix.data[tstp,i] * x
    end
end

#=
### *𝔾ˡᵐⁱˣ* : *Traits*
=#

"""
    Base.:+(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T})

Operation `+` for two `𝔾ˡᵐⁱˣ` objects.
"""
function Base.:+(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T}) where {T}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    𝔾ˡᵐⁱˣ(lmix1.ntime, lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data + lmix2.data)
end

"""
    Base.:-(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T})

Operation `-` for two `𝔾ˡᵐⁱˣ` objects.
"""
function Base.:-(lmix1::𝔾ˡᵐⁱˣ{T}, lmix2::𝔾ˡᵐⁱˣ{T}) where {T}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    𝔾ˡᵐⁱˣ(lmix1.ntime, lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data - lmix2.data)
end

"""
    Base.:*(lmix::𝔾ˡᵐⁱˣ{T}, x)

Operation `*` for a `𝔾ˡᵐⁱˣ` object and a scalar value.
"""
function Base.:*(lmix::𝔾ˡᵐⁱˣ{T}, x) where {T}
    cx = convert(T, x)
    𝔾ˡᵐⁱˣ(lmix.ntime, lmix.ntau, lmix.ndim1, lmix.ndim2, lmix.data * cx)
end

"""
    Base.:*(x, lmix::𝔾ˡᵐⁱˣ{T})

Operation `*` for a scalar value and a `𝔾ˡᵐⁱˣ` object.
"""
Base.:*(x, lmix::𝔾ˡᵐⁱˣ{T}) where {T} = Base.:*(lmix, x)

#=
*Right-mixing Green's Function* :

The right-mixing component of contour Green's function reads

```math
\begin{equation}
G^{\lceil}(\tau,t') =  -i \langle c(\tau) c^{\dagger}(t')  \rangle,
\end{equation}
```

where ``t' \in \mathcal{C}_1 \cup \mathcal{C}_2`` and
``\tau \in \mathcal{C}_3``.
=#

#=
### *𝔾ʳᵐⁱˣ* : *Struct*
=#

"""
    𝔾ʳᵐⁱˣ{T}

Right-mixing component (``G^{⌈}``) of contour Green's function.

See also: [`𝔾ᵐᵃᵗ`](@ref), [`𝔾ʳᵉᵗ`](@ref), [`𝔾ˡᵉˢˢ`](@ref).
"""
mutable struct 𝔾ʳᵐⁱˣ{T} <: CnAbstractMatrix{T}
    sign  :: I64 # Used to distinguish fermions and bosons
    ntime :: I64
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataL :: Ref{𝔾ˡᵐⁱˣ{T}}
end

#=
### *𝔾ʳᵐⁱˣ* : *Constructors*
=#

"""
    𝔾ʳᵐⁱˣ(sign::I64, lmix::𝔾ˡᵐⁱˣ{T})

Constructor. Note that the `rmix` component is not independent. We use
the `lmix` component to initialize it.
"""
function 𝔾ʳᵐⁱˣ(sign::I64, lmix::𝔾ˡᵐⁱˣ{T}) where {T}
    # Sanity check
    @assert sign in (BOSE, FERMI)

    # Setup properties
    # Extract parameters from `lmix`
    ntime = lmix.ntime
    ntau  = lmix.ntau
    ndim1 = lmix.ndim1
    ndim2 = lmix.ndim2
    #
    # We don't allocate memory for `dataL` directly, but let it point to
    # the `lmix` object.
    dataL = Ref(lmix)

    # Call the default constructor
    𝔾ʳᵐⁱˣ(sign, ntime, ntau, ndim1, ndim2, dataL)
end

#=
### *𝔾ʳᵐⁱˣ* : *Indexing*
=#

"""
    Base.getindex(rmix::𝔾ʳᵐⁱˣ{T}, i::I64, j::I64)

Visit the element stored in `𝔾ʳᵐⁱˣ` object.
"""
function Base.getindex(rmix::𝔾ʳᵐⁱˣ{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ rmix.ntau
    @assert 1 ≤ j ≤ rmix.ntime

    # Return G^{⌈}(τᵢ, tⱼ)
    (rmix.dataL[])[j,rmix.ntau - i + 1]' * (-rmix.sign)
end

#=
*Lesser Green's Function* :

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
### *𝔾ˡᵉˢˢ* : *Struct*
=#

"""
    𝔾ˡᵉˢˢ{T}

Lesser component (``G^{<}``) of contour Green's function.

See also: [`𝔾ᵐᵃᵗ`](@ref), [`𝔾ʳᵉᵗ`](@ref), [`𝔾ˡᵐⁱˣ`](@ref).
"""
mutable struct 𝔾ˡᵉˢˢ{T} <: CnAbstractMatrix{T}
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *𝔾ˡᵉˢˢ* : *Constructors*
=#

"""
    𝔾ˡᵉˢˢ(ntime::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function 𝔾ˡᵉˢˢ(ntime::I64, ndim1::I64, ndim2::I64, v::T) where {T}
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
    𝔾ˡᵉˢˢ(ntime, ndim1, ndim2, data)
end

"""
    𝔾ˡᵉˢˢ(ntime::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ˡᵉˢˢ(ntime::I64, ndim1::I64, ndim2::I64)
    𝔾ˡᵉˢˢ(ntime, ndim1, ndim2, CZERO)
end

"""
    𝔾ˡᵉˢˢ(ntime::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ˡᵉˢˢ(ntime::I64, ndim1::I64)
    𝔾ˡᵉˢˢ(ntime, ndim1, ndim1, CZERO)
end

"""
    𝔾ˡᵉˢˢ(ntime::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function 𝔾ˡᵉˢˢ(ntime::I64, x::Element{T}) where {T}
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
    𝔾ˡᵉˢˢ(ntime, ndim1, ndim2, data)
end

"""
    𝔾ˡᵉˢˢ(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function 𝔾ˡᵉˢˢ(C::Cn, x::Element{T}) where {T}
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
    𝔾ˡᵉˢˢ(C.ntime, C.ndim1, C.ndim2, data)
end

"""
    𝔾ˡᵉˢˢ(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function 𝔾ˡᵉˢˢ(C::Cn, v::T) where {T}
    𝔾ˡᵉˢˢ(C.ntime, C.ndim1, C.ndim2, v)
end

"""
    𝔾ˡᵉˢˢ(C::Cn)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function 𝔾ˡᵉˢˢ(C::Cn)
    𝔾ˡᵉˢˢ(C.ntime, C.ndim1, C.ndim2, CZERO)
end

#=
### *𝔾ˡᵉˢˢ* : *Properties*
=#

"""
    getdims(less::𝔾ˡᵉˢˢ{T})

Return the dimensional parameters of contour function.

See also: [`𝔾ˡᵉˢˢ`](@ref).
"""
function getdims(less::𝔾ˡᵉˢˢ{T}) where {T}
    return (less.ndim1, less.ndim2)
end

"""
    getsize(less::𝔾ˡᵉˢˢ{T})

Return the size of contour function.

See also: [`𝔾ˡᵉˢˢ`](@ref).
"""
function getsize(less::𝔾ˡᵉˢˢ{T}) where {T}
    return less.ntime
end

"""
    equaldims(less::𝔾ˡᵉˢˢ{T})

Return whether the dimensional parameters are equal.

See also: [`𝔾ˡᵉˢˢ`](@ref).
"""
function equaldims(less::𝔾ˡᵉˢˢ{T}) where {T}
    return less.ndim1 == less.ndim2
end

"""
    iscompatible(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T})

Judge whether two `𝔾ˡᵉˢˢ` objects are compatible.
"""
function iscompatible(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T}) where {T}
    getsize(less1) == getsize(less2) &&
    getdims(less1) == getdims(less2)
end

"""
    iscompatible(C::Cn, less::𝔾ˡᵉˢˢ{T})

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `𝔾ˡᵉˢˢ{T}` object).
"""
function iscompatible(C::Cn, less::𝔾ˡᵉˢˢ{T}) where {T}
    C.ntime == getsize(less) &&
    getdims(C) == getdims(less)
end

"""
    iscompatible(less::𝔾ˡᵉˢˢ{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `𝔾ˡᵉˢˢ{T}` object).
"""
iscompatible(less::𝔾ˡᵉˢˢ{T}, C::Cn) where {T} = iscompatible(C, less)

"""
    distance(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T}, tstp::I64)

Calculate distance between two `𝔾ˡᵉˢˢ` objects at given time step `tstp`.
"""
function distance(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T}, tstp::I64) where {T}
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
### *𝔾ˡᵉˢˢ* : *Indexing*
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
    Base.getindex(less::𝔾ˡᵉˢˢ{T}, i::I64, j::I64)

Visit the element stored in `𝔾ˡᵉˢˢ` object.
"""
function Base.getindex(less::𝔾ˡᵉˢˢ{T}, i::I64, j::I64) where {T}
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
    Base.setindex!(less::𝔾ˡᵉˢˢ{T}, x::Element{T}, i::I64, j::I64)

Setup the element in `𝔾ˡᵉˢˢ` object.
"""
function Base.setindex!(less::𝔾ˡᵉˢˢ{T}, x::Element{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(less)
    @assert 1 ≤ i ≤ less.ntime
    @assert 1 ≤ j ≤ less.ntime

    # G^{<}(tᵢ, tⱼ) = x
    less.data[i,j] = copy(x)
end

"""
    Base.setindex!(less::𝔾ˡᵉˢˢ{T}, v::T, i::I64, j::I64)

Setup the element in `𝔾ˡᵉˢˢ` object.
"""
function Base.setindex!(less::𝔾ˡᵉˢˢ{T}, v::T, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ less.ntime
    @assert 1 ≤ j ≤ less.ntime

    # G^{<}(tᵢ, tⱼ) .= v
    fill!(less.data[i,j], v)
end

#=
### *𝔾ˡᵉˢˢ* : *Operations*
=#

"""
    memset!(less::𝔾ˡᵉˢˢ{T}, x)

Reset all the matrix elements of `less` to `x`. `x` should be a
scalar number.
"""
function memset!(less::𝔾ˡᵉˢˢ{T}, x) where {T}
    cx = convert(T, x)
    for i=1:less.ntime
        for j=1:less.ntime
            fill!(less.data[j,i], cx)
        end
    end
end

"""
    memset!(less::𝔾ˡᵉˢˢ{T}, tstp::I64, x)

Reset the matrix elements of `less` at given time step `tstp` to `x`. `x`
should be a scalar number.
"""
function memset!(less::𝔾ˡᵉˢˢ{T}, tstp::I64, x) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    cx = convert(T, x)
    for i=1:tstp
        fill!(less.data[i,tstp], cx)
    end
end

"""
    zeros!(less::𝔾ˡᵉˢˢ{T})

Reset all the matrix elements of `less` to `ZERO`.
"""
zeros!(less::𝔾ˡᵉˢˢ{T}) where {T} = memset!(less, zero(T))

"""
    zeros!(less::𝔾ˡᵉˢˢ{T}, tstp::I64)

Reset the matrix elements of `less` at given time step `tstp` to `ZERO`.
"""
zeros!(less::𝔾ˡᵉˢˢ{T}, tstp::I64) where {T} = memset!(less, tstp, zero(T))

"""
    memcpy!(src::𝔾ˡᵉˢˢ{T}, dst::𝔾ˡᵉˢˢ{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::𝔾ˡᵉˢˢ{T}, dst::𝔾ˡᵉˢˢ{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::𝔾ˡᵉˢˢ{T}, dst::𝔾ˡᵉˢˢ{T}, tstp::I64)

Copy some matrix elements from `src` to `dst`. Only the matrix elements
at given time step `tstp` are copied.
"""
function memcpy!(src::𝔾ˡᵉˢˢ{T}, dst::𝔾ˡᵉˢˢ{T}, tstp::I64) where {T}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    for i=1:tstp
        dst.data[i,tstp] = copy(src.data[i,tstp])
    end
end

"""
    incr!(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T}, tstp::I64, alpha::T)

Add a `𝔾ˡᵉˢˢ` with given weight (`alpha`) at given time step `tstp` to
another `𝔾ˡᵉˢˢ`.
"""
function incr!(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T}, tstp::I64, alpha::T) where {T}
    @assert iscompatible(less1, less2)
    @assert 1 ≤ tstp ≤ less2.ntime
    for i = 1:tstp
        @. less1.data[i,tstp] = less1.data[i,tstp] + less2.data[i,tstp] * alpha
    end
end

"""
    smul!(less::𝔾ˡᵉˢˢ{T}, tstp::I64, alpha::T)

Multiply a `𝔾ˡᵉˢˢ` with given weight (`alpha`) at given time
step `tstp`.
"""
function smul!(less::𝔾ˡᵉˢˢ{T}, tstp::I64, alpha::T) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    for i = 1:tstp
        @. less.data[i,tstp] = less.data[i,tstp] * alpha
    end
end

"""
    smul!(x::Cf{T}, less::𝔾ˡᵉˢˢ{T}, tstp::I64)

Left multiply a `𝔾ˡᵉˢˢ` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(x::Cf{T}, less::𝔾ˡᵉˢˢ{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    for i = 1:tstp
        less.data[i,tstp] = x[i] * less.data[i,tstp]
    end
end

"""
    smul!(less::𝔾ˡᵉˢˢ{T}, x::Element{T}, tstp::I64)

Right multiply a `𝔾ˡᵉˢˢ` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(less::𝔾ˡᵉˢˢ{T}, x::Element{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    for i = 1:tstp
        less.data[i,tstp] = less.data[i,tstp] * x
    end
end

#=
### *𝔾ˡᵉˢˢ* : *Traits*
=#

"""
    Base.:+(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T})

Operation `+` for two `𝔾ˡᵉˢˢ` objects.
"""
function Base.:+(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T}) where {T}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    𝔾ˡᵉˢˢ(less1.ntime, less1.ndim1, less1.ndim2, less1.data + less2.data)
end

"""
    Base.:-(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T})

Operation `-` for two `𝔾ˡᵉˢˢ` objects.
"""
function Base.:-(less1::𝔾ˡᵉˢˢ{T}, less2::𝔾ˡᵉˢˢ{T}) where {T}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    𝔾ˡᵉˢˢ(less1.ntime, less1.ndim1, less1.ndim2, less1.data - less2.data)
end

"""
    Base.:*(less::𝔾ˡᵉˢˢ{T}, x)

Operation `*` for a `𝔾ˡᵉˢˢ` object and a scalar value.
"""
function Base.:*(less::𝔾ˡᵉˢˢ{T}, x) where {T}
    cx = convert(T, x)
    𝔾ˡᵉˢˢ(less.ntime, less.ndim1, less.ndim2, less.data * cx)
end

"""
    Base.:*(x, less::𝔾ˡᵉˢˢ{T})

Operation `*` for a scalar value and a `𝔾ˡᵉˢˢ` object.
"""
Base.:*(x, less::𝔾ˡᵉˢˢ{T}) where {T} = Base.:*(less, x)

#=
*Greater Green's Function* :

The greater component of contour Green's function reads

```math
\begin{equation}
G^{>}(t,t') = - i \langle c(t) c^{\dagger}(t') \rangle,
\end{equation}
```

where ``t,\ t' \in \mathcal{C}_1 \cup \mathcal{C}_2``. Its hermitian
conjugate yields

```math
\begin{equation}
G^{>}(t,t')^{*} = -G^{>}(t',t).
\end{equation}
```

The greater component is related to the retarded, advanced, and Keldysh
Green's functions via

```math
\begin{equation}
G^{>} = \frac{1}{2}(G^{K} + G^{R} - G^{A}).
\end{equation}
```
=#

#=
### *𝔾ᵍᵗʳ* : *Struct*
=#

"""
    𝔾ᵍᵗʳ{T}

Greater component (``G^{>}``) of contour Green's function.

See also: [`𝔾ʳᵉᵗ`](@ref), [`𝔾ˡᵐⁱˣ`](@ref), [`𝔾ˡᵉˢˢ`](@ref).
"""
mutable struct 𝔾ᵍᵗʳ{T} <: CnAbstractMatrix{T}
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataL :: Ref{𝔾ˡᵉˢˢ{T}}
    dataR :: Ref{𝔾ʳᵉᵗ{T}}
end

#=
### *𝔾ᵍᵗʳ* : *Constructors*
=#

"""
    𝔾ᵍᵗʳ(less::𝔾ˡᵉˢˢ{T}, ret::𝔾ʳᵉᵗ{T})

Constructor. Note that the `gtr` component is not independent. We use
the `less` and `ret` components to initialize it.
"""
function 𝔾ᵍᵗʳ(less::𝔾ˡᵉˢˢ{T}, ret::𝔾ʳᵉᵗ{T}) where {T}
    # Setup properties
    # Extract parameters from `less`
    ntime = less.ntime
    ndim1 = less.ndim1
    ndim2 = less.ndim2
    #
    # We don't allocate memory for `dataL` and `dataR` directly, but
    # let them point to  `less` and `ret` objects, respectively.
    dataL = Ref(less)
    dataR = Ref(ret)

    # Call the default constructor
    𝔾ᵍᵗʳ(ntime, ndim1, ndim2, dataL, dataR)
end

#=
### *𝔾ᵍᵗʳ* : *Indexing*
=#

"""
    Base.getindex(gtr::𝔾ᵍᵗʳ{T}, i::I64, j::I64)

Visit the element stored in `𝔾ᵍᵗʳ` object.
"""
function Base.getindex(gtr::𝔾ᵍᵗʳ{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ gtr.ntime
    @assert 1 ≤ j ≤ gtr.ntime

    # Return G^{>}(tᵢ, tⱼ)
    gtr.dataL[][i,j] + gtr.dataR[][i,j]
end

#=
*Full Contour Green's Functions* :

As mentioned before, there are six linearly independent ''physical''
Green's functions. Assuming the hermitian symmetry, the number of
independent components is limited to four. Hence, in this package,
we just use ``{G^{M},\ G^{R},\ G^{\rceil},\ G^{<}}`` as the minimal
set of independent contour-ordered Green's functions. We call them
as `mat`, `ret`, `lmix`, and `less` components throughout the package.
=#

#=
### *ℱ* : *Struct*
=#

"""
    ℱ{T}

Standard contour-ordered Green's function. It includes four independent
components, namely `mat`, `ret`, `lmix`, and `less`.
"""
mutable struct ℱ{T} <: CnAbstractFunction{T}
    sign :: I64 # Used to distinguish fermions and bosons
    mat  :: 𝔾ᵐᵃᵗ{T}
    ret  :: 𝔾ʳᵉᵗ{T}
    lmix :: 𝔾ˡᵐⁱˣ{T}
    less :: 𝔾ˡᵉˢˢ{T}
end

#=
### *ℱ* : *Constructors*
=#

"""
    ℱ(C::Cn, v::T, sign::I64)

Standard constructor. This function is initialized by `v`.
"""
function ℱ(C::Cn, v::T, sign::I64) where {T}
    # Sanity check
    @assert sign in (BOSE, FERMI)

    # Create mat, ret, lmix, and less.
    mat  = 𝔾ᵐᵃᵗ(C, v)
    ret  = 𝔾ʳᵉᵗ(C, v)
    lmix = 𝔾ˡᵐⁱˣ(C, v)
    less = 𝔾ˡᵉˢˢ(C, v)

    # Call the default constructor
    ℱ(sign, mat, ret, lmix, less)
end

"""
    ℱ(C::Cn, sign::I64 = FERMI)

Constructor. Create a contour Green's function with zero initial values.
"""
function ℱ(C::Cn, sign::I64 = FERMI)
    # Setup sign
    @assert sign in (BOSE, FERMI)

    # Create mat, ret, lmix, and less.
    mat  = 𝔾ᵐᵃᵗ(C)
    ret  = 𝔾ʳᵉᵗ(C)
    lmix = 𝔾ˡᵐⁱˣ(C)
    less = 𝔾ˡᵉˢˢ(C)

    # Call the default constructor
    ℱ(sign, mat, ret, lmix, less)
end

#=
### *ℱ* : *Properties*
=#

"""
    getdims(cfm::ℱ{T})

Return the dimensional parameters of contour Green's function.

See also: [`ℱ`](@ref).
"""
function getdims(cfm::ℱ{T}) where {T}
    return getdims(cfm.less)
end

"""
    getntime(cfm::ℱ{T})

Return the `ntime` parameter of contour Green's function.
"""
function getntime(cfm::ℱ{T}) where {T}
    return getsize(cfm.less)
end

"""
    getntau(cfm::ℱ{T})

Return the `ntau` parameter of contour Green's function.
"""
function getntau(cfm::ℱ{T}) where {T}
    return getsize(cfm.mat)
end

"""
    getsign(cfm::ℱ{T})

Return the `sign` parameter of contour Green's function.
"""
function getsign(cfm::ℱ{T}) where {T}
    return cfm.sign
end

"""
    equaldims(cfm::ℱ{T})

Return whether the dimensional parameters are equal.

See also: [`ℱ`](@ref).
"""
function equaldims(cfm::ℱ{T}) where {T}
    return equaldims(cfm.less)
end

"""
    density(cfm::ℱ{T}, tstp::I64)

Returns the density matrix at given time step `tstp`. If `tstp = 0`,
it denotes the equilibrium state. However, when `tstp > 0`, it means
the nonequilibrium state.

See also: [`𝔾ᵐᵃᵗ`](@ref), [`𝔾ˡᵉˢˢ`](@ref).
"""
function density(cfm::ℱ{T}, tstp::I64) where {T}
    # Sanity check
    @assert 0 ≤ tstp ≤ getntime(cfm)

    if tstp == 0
        return -cfm.mat[getntime(cfm)]
    else
        return cfm.less[tstp, tstp] * getsign(cfm) * CZI
    end
end

"""
    distance(cfm1::ℱ{T}, cfm2::ℱ{T}, tstp::I64)

Calculate distance between two `ℱ` objects at given time step `tstp`.
"""
function distance(cfm1::ℱ{T}, cfm2::ℱ{T}, tstp::I64) where {T}
    # Sanity check
    @assert 0 ≤ tstp ≤ getntime(cfm1)

    err = 0.0
    #
    if tstp == 0
        err = err + distance(cfm1.mat, cfm2.mat)
    else
        err = err + distance(cfm1.ret, cfm2.ret, tstp)
        err = err + distance(cfm1.lmix, cfm2.lmix, tstp)
        err = err + distance(cfm1.less, cfm2.less, tstp)
    end
    #
    return err
end

#=
### *ℱ* : *Operations*
=#

"""
    memset!(cfm::ℱ{T}, x)

Reset all the matrix elements of `cfm` to `x`. `x` should be a
scalar number.
"""
function memset!(cfm::ℱ{T}, x) where {T}
    memset!(cfm.mat, x)
    memset!(cfm.ret, x)
    memset!(cfm.lmix, x)
    memset!(cfm.less, x)
end

"""
    memset!(cfm::ℱ{T}, tstp::I64, x)

Reset the matrix elements of `cfm` at given time step `tstp` to `x`. `x`
should be a scalar number. Note that `tstp = 0` means the equilibrium
state, at this time this function will reset the Matsubara component
only. However, when `tstp > 0`, the `ret`, `lmix`, and `less` components
will be changed.
"""
function memset!(cfm::ℱ{T}, tstp::I64, x) where {T}
    @assert 0 ≤ tstp ≤ getntime(cfm)
    if tstp > 0
        memset!(cfm.ret, tstp, x)
        memset!(cfm.lmix, tstp, x)
        memset!(cfm.less, tstp, x)
    else
        @assert tstp == 0
        memset!(cfm.mat, x)
    end
end

"""
    zeros!(cfm::ℱ{T})

Reset all the matrix elements of `cfm` to `ZERO`.
"""
zeros!(cfm::ℱ{T}) where {T} = memset!(cfm, zero(T))

"""
    zeros!(cfm::ℱ{T}, tstp::I64)

Reset the matrix elements of `cfm` at given time step `tstp` to `ZERO`.
"""
zeros!(cfm::ℱ{T}, tstp::I64) where {T} = memset!(cfm, tstp, zero(T))

"""
    memcpy!(src::ℱ{T}, dst::ℱ{T}, tstp::I64)

Copy contour Green's function at given time step `tstp`. Note that
`tstp = 0` means the equilibrium state, at this time this function
will copy the Matsubara component only. However, when `tstp > 0`,
the `ret`, `lmix`, and `less` components will be copied.
"""
function memcpy!(src::ℱ{T}, dst::ℱ{T}, tstp::I64) where {T}
    @assert 0 ≤ tstp ≤ getntime(src)
    if tstp > 0
        memcpy!(src.ret, dst.ret, tstp)
        memcpy!(src.lmix, dst.lmix, tstp)
        memcpy!(src.less, dst.less, tstp)
    else
        @assert tstp == 0
        memcpy!(src.mat, dst.mat)
    end
end

"""
    incr!(cfm1::ℱ{T}, cfm2::ℱ{T}, tstp::I64, alpha)

Adds a `ℱ` with given weight (`alpha`) to another `ℱ` (at given
time step `tstp`).
"""
function incr!(cfm1::ℱ{T}, cfm2::ℱ{T}, tstp::I64, alpha) where {T}
    @assert 0 ≤ tstp ≤ getntime(cfm2)
    α = convert(T, alpha)
    if tstp > 0
        incr!(cfm1.ret, cfm2.ret, tstp, α)
        incr!(cfm1.lmix, cfm2.lmix, tstp, α)
        incr!(cfm1.less, cfm2.less, tstp, α)
    else
        @assert tstp == 0
        incr!(cfm1.mat, cfm2.mat, α)
    end
end

"""
    incr!(cfm1::ℱ{T}, cfm2::ℱ{T}, alpha)

Adds a `ℱ` with given weight (`alpha`) to another `ℱ` (at all
possible time step `tstp`).
"""
function incr!(cfm1::ℱ{T}, cfm2::ℱ{T}, alpha) where {T}
    for tstp = 0:getntime(cfm2)
        incr!(cfm1, cfm2, tstp, alpha)
    end
end

"""
    smul!(cfm::ℱ{T}, tstp::I64, alpha)

Multiply a `ℱ` with given weight (`alpha`) at given time
step `tstp`.
"""
function smul!(cfm::ℱ{T}, tstp::I64, alpha) where {T}
    @assert 0 ≤ tstp ≤ getntime(cfm)
    α = convert(T, alpha)
    if tstp > 0
        smul!(cfm.ret, tstp, α)
        smul!(cfm.lmix, tstp, α)
        smul!(cfm.less, tstp, α)
    else
        @assert tstp == 0
        smul!(cfm.mat, α)
    end
end

"""
    smul!(cff::Cf{T}, cfm::ℱ{T}, tstp::I64)

Left multiply a `ℱ` with given weight (`Cf`) at given time
step `tstp`.
"""
function smul!(cff::Cf{T}, cfm::ℱ{T}, tstp::I64) where {T}
    @assert 0 ≤ tstp ≤ getntime(cfm)
    if tstp > 0
        smul!(cff[tstp], cfm.ret, tstp)
        smul!(cff[tstp], cfm.lmix, tstp)
        smul!(cff, cfm.less, tstp)
    else
        @assert tstp == 0
        smul!(cff[0], cfm.mat)
    end
end

"""
    smul!(cfm::ℱ{T}, cff::Cf{T}, tstp::I64)

Right multiply a `ℱ` with given weight (`Cf`) at given time
step `tstp`.
"""
function smul!(cfm::ℱ{T}, cff::Cf{T}, tstp::I64) where {T}
    @assert 0 ≤ tstp ≤ getntime(cfm)
    if tstp > 0
        smul!(cfm.ret, cff, tstp)
        smul!(cfm.lmix, cff[0], tstp)
        smul!(cfm.less, cff[tstp], tstp)
    else
        @assert tstp == 0
        smul!(cfm.mat, cff[0])
    end
end

#=
### *ℱ* : *I/O*
=#

"""
    read!(fname::AbstractString, cfm::ℱ{T})

Read the contour Green's functions from given file.
"""
function read!(fname::AbstractString, cfm::ℱ{T}) where {T}
end

"""
    write(fname::AbstractString, cfm::ℱ{T})

Write the contour Green's functions to given file.
"""
function write(fname::AbstractString, cfm::ℱ{T}) where {T}
end

#=
### *ℱ* : *Traits*
=#

"""
    Base.getproperty(cfm::ℱ{T}, symbol::Symbol)

Visit the properties stored in `ℱ` object. It provides access to
the Matsubara (minus, `matm`), advanced (`adv`), right-mixing (`rmix`),
and greater (`gtr`) components of the contour-ordered Green's function.
"""
function Base.getproperty(cfm::ℱ{T}, symbol::Symbol) where {T}
    if symbol === :matm
        return 𝔾ᵐᵃᵗᵐ(cfm.sign, cfm.mat)
    #
    elseif symbol === :adv
        error("Sorry, this feature has not been implemented")
    #
    elseif symbol === :rmix
        return 𝔾ʳᵐⁱˣ(cfm.sign, cfm.lmix)
    #
    elseif symbol === :gtr
        return 𝔾ᵍᵗʳ(cfm.less, cfm.ret)
    #
    else # Fallback to getfield()
        return getfield(cfm, symbol)
    end
end

#=
### *gᵐᵃᵗ* : *Struct*
=#

"""
    gᵐᵃᵗ{S}

Matsubara component (``G^{M}``) of contour Green's function at given
time step `tstp`. Actually, `gᵐᵃᵗ{S}` is equivalent to `𝔾ᵐᵃᵗ{T}`.

See also: [`gʳᵉᵗ`](@ref), [`gˡᵐⁱˣ`](@ref), [`gˡᵉˢˢ`](@ref).
"""
mutable struct gᵐᵃᵗ{S} <: CnAbstractVector{S}
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{S}
end

#=
### *gᵐᵃᵗ* : *Constructors*
=#

"""
    gᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64, v::S)

Constructor. All the vector elements are set to be `v`.
"""
function gᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64, v::S) where {S}
    # Sanity check
    @assert ntau ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create Element{S}
    element = fill(v, ndim1, ndim2)

    # Create VecArray{S}, whose size is indeed (ntau,)
    data = VecArray{S}(undef, ntau)
    for i = 1:ntau
        data[i] = copy(element)
    end

    # Call the default constructor
    gᵐᵃᵗ(ntau, ndim1, ndim2, data)
end

"""
    gᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the vector elements are set to be `CZERO`.
"""
function gᵐᵃᵗ(ntau::I64, ndim1::I64, ndim2::I64)
    gᵐᵃᵗ(ntau, ndim1, ndim2, CZERO)
end

"""
    gᵐᵃᵗ(ntau::I64, ndim1::I64)

Constructor. All the vector elements are set to be `CZERO`.
"""
function gᵐᵃᵗ(ntau::I64, ndim1::I64)
    gᵐᵃᵗ(ntau, ndim1, ndim1, CZERO)
end

"""
    gᵐᵃᵗ(ntau::I64, x::Element{S})

Constructor. The vector is initialized by `x`.
"""
function gᵐᵃᵗ(ntau::I64, x::Element{S}) where {S}
    # Sanity check
    @assert ntau ≥ 2

    ndim1, ndim2 = size(x)
    data = VecArray{S}(undef, ntau)
    for i = 1:ntau
        data[i] = copy(x)
    end

    # Call the default constructor
    gᵐᵃᵗ(ntau, ndim1, ndim2, data)
end

#=
### *gᵐᵃᵗ* : *Properties*
=#

"""
    getdims(mat::gᵐᵃᵗ{S})

Return the dimensional parameters of contour function.

See also: [`gᵐᵃᵗ`](@ref).
"""
function getdims(mat::gᵐᵃᵗ{S}) where {S}
    return (mat.ndim1, mat.ndim2)
end

"""
    getsize(mat::gᵐᵃᵗ{S})

Return the size of contour function.

See also: [`gᵐᵃᵗ`](@ref).
"""
function getsize(mat::gᵐᵃᵗ{S}) where {S}
    return mat.ntau
end

"""
    equaldims(mat::gᵐᵃᵗ{S})

Return whether the dimensional parameters are equal.

See also: [`gᵐᵃᵗ`](@ref).
"""
function equaldims(mat::gᵐᵃᵗ{S}) where {S}
    return mat.ndim1 == mat.ndim2
end

"""
    iscompatible(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S})

Judge whether two `gᵐᵃᵗ` objects are compatible.
"""
function iscompatible(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}) where {S}
    getsize(mat1) == getsize(mat2) &&
    getdims(mat1) == getdims(mat2)
end

"""
    iscompatible(mat1::gᵐᵃᵗ{S}, mat2::𝔾ᵐᵃᵗ{S})

Judge whether the `gᵐᵃᵗ` and `𝔾ᵐᵃᵗ` objects are compatible.
"""
function iscompatible(mat1::gᵐᵃᵗ{S}, mat2::𝔾ᵐᵃᵗ{S}) where {S}
    getsize(mat1) == getsize(mat2) &&
    getdims(mat1) == getdims(mat2)
end

"""
    iscompatible(mat1::𝔾ᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S})

Judge whether the `gᵐᵃᵗ` and `𝔾ᵐᵃᵗ` objects are compatible.
"""
iscompatible(mat1::𝔾ᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}) where {S} = iscompatible(mat2, mat1)

"""
    iscompatible(C::Cn, mat::gᵐᵃᵗ{S})

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `gᵐᵃᵗ{S}` object).
"""
function iscompatible(C::Cn, mat::gᵐᵃᵗ{S}) where {S}
    C.ntau == getsize(mat) &&
    getdims(C) == getdims(mat)
end

"""
    iscompatible(mat::gᵐᵃᵗ{S}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `gᵐᵃᵗ{S}` object).
"""
iscompatible(mat::gᵐᵃᵗ{S}, C::Cn) where {S} = iscompatible(C, mat)

"""
    distance(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S})

Calculate distance between two `gᵐᵃᵗ` objects.
"""
function distance(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}) where {S}
    @assert iscompatible(mat1, mat2)

    err = 0.0
    #
    for m = 1:mat1.ntau
        err = err + abs(sum(mat1.data[m] - mat2.data[m]))
    end
    #
    return err
end

"""
    distance(mat1::gᵐᵃᵗ{S}, mat2::𝔾ᵐᵃᵗ{S})

Calculate distance between a `gᵐᵃᵗ` object and a `𝔾ᵐᵃᵗ` object.
"""
function distance(mat1::gᵐᵃᵗ{S}, mat2::𝔾ᵐᵃᵗ{S}) where {S}
    @assert iscompatible(mat1, mat2)

    err = 0.0
    #
    for m = 1:mat1.ntau
        err = err + abs(sum(mat1.data[m] - mat2.data[m,1]))
    end
    #
    return err
end

"""
    distance(mat1::𝔾ᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S})

Calculate distance between a `gᵐᵃᵗ` object and a `𝔾ᵐᵃᵗ` object.
"""
distance(mat1::𝔾ᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}) where {S} = distance(mat2, mat1)

#=
### *gᵐᵃᵗ* : *Indexing*
=#

"""
    Base.getindex(mat::gᵐᵃᵗ{S}, ind::I64)

Visit the element stored in `gᵐᵃᵗ` object.
"""
function Base.getindex(mat::gᵐᵃᵗ{S}, ind::I64) where {S}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # Return G^{M}(τᵢ)
    mat.data[ind]
end

"""
    Base.setindex!(mat::gᵐᵃᵗ{S}, x::Element{S}, ind::I64)

Setup the element in `gᵐᵃᵗ` object.
"""
function Base.setindex!(mat::gᵐᵃᵗ{S}, x::Element{S}, ind::I64) where {S}
    # Sanity check
    @assert size(x) == getdims(mat)
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) = x
    mat.data[ind] = copy(x)
end

"""
    Base.setindex!(mat::gᵐᵃᵗ{S}, v::S, ind::I64)

Setup the element in `gᵐᵃᵗ` object.
"""
function Base.setindex!(mat::gᵐᵃᵗ{S}, v::S, ind::I64) where {S}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) .= v
    fill!(mat.data[ind], v)
end

#=
### *gᵐᵃᵗ* : *Operations*
=#

"""
    memset!(mat::gᵐᵃᵗ{S}, x)

Reset all the vector elements of `mat` to `x`. `x` should be a
scalar number.
"""
function memset!(mat::gᵐᵃᵗ{S}, x) where {S}
    cx = convert(S, x)
    for i = 1:mat.ntau
        fill!(mat.data[i], cx)
    end
end

"""
    zeros!(mat::gᵐᵃᵗ{S})

Reset all the vector elements of `mat` to `ZERO`.
"""
zeros!(mat::gᵐᵃᵗ{S}) where {S} = memset!(mat, zero(S))

"""
    memcpy!(src::gᵐᵃᵗ{S}, dst::gᵐᵃᵗ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::gᵐᵃᵗ{S}, dst::gᵐᵃᵗ{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::𝔾ᵐᵃᵗ{S}, dst::gᵐᵃᵗ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::𝔾ᵐᵃᵗ{S}, dst::gᵐᵃᵗ{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data[:,1])
end

"""
    memcpy!(src::gᵐᵃᵗ{S}, dst::𝔾ᵐᵃᵗ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::gᵐᵃᵗ{S}, dst::𝔾ᵐᵃᵗ{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data[:,1] = copy(src.data)
end

"""
    incr!(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}, alpha::S)

Add a `gᵐᵃᵗ` with given weight (`alpha`) to another `gᵐᵃᵗ`.
"""
function incr!(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}, alpha::S) where {S}
    @assert iscompatible(mat1, mat2)
    for i = 1:mat2.ntau
        @. mat1.data[i] = mat1.data[i] + mat2.data[i] * alpha
    end
end

"""
    incr!(mat1::𝔾ᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}, alpha::S)

Add a `gᵐᵃᵗ` with given weight (`alpha`) to a `𝔾ᵐᵃᵗ`.
"""
function incr!(mat1::𝔾ᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}, alpha::S) where {S}
    @assert iscompatible(mat1, mat2)
    for i = 1:mat2.ntau
        @. mat1.data[i,1] = mat1.data[i,1] + mat2.data[i] * alpha
    end
end

"""
    incr!(mat1::gᵐᵃᵗ{S}, mat2::𝔾ᵐᵃᵗ{S}, alpha::S)

Add a `𝔾ᵐᵃᵗ` with given weight (`alpha`) to a `gᵐᵃᵗ`.
"""
function incr!(mat1::gᵐᵃᵗ{S}, mat2::𝔾ᵐᵃᵗ{S}, alpha::S) where {S}
    @assert iscompatible(mat1, mat2)
    for i = 1:mat1.ntau
        @. mat1.data[i] = mat1.data[i] + mat2.data[i,1] * alpha
    end
end

"""
    smul!(mat::gᵐᵃᵗ{S}, alpha::S)

Multiply a `gᵐᵃᵗ` with given weight (`alpha`).
"""
function smul!(mat::gᵐᵃᵗ{S}, alpha::S) where {S}
    for i = 1:mat.ntau
        @. mat.data[i] = mat.data[i] * alpha
    end
end

"""
    smul!(x::Element{S}, mat::gᵐᵃᵗ{S})

Left multiply a `gᵐᵃᵗ` with given weight (`x`).
"""
function smul!(x::Element{S}, mat::gᵐᵃᵗ{S}) where {S}
    for i = 1:mat.ntau
        mat.data[i] = x * mat.data[i]
    end
end

"""
    smul!(mat::gᵐᵃᵗ{S}, x::Element{S})

Right multiply a `gᵐᵃᵗ` with given weight (`x`).
"""
function smul!(mat::gᵐᵃᵗ{S}, x::Element{S}) where {S}
    for i = 1:mat.ntau
        mat.data[i] = mat.data[i] * x
    end
end

#=
### *gᵐᵃᵗ* : *Traits*
=#

"""
    Base.:+(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S})

Operation `+` for two `gᵐᵃᵗ` objects.
"""
function Base.:+(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}) where {S}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    gᵐᵃᵗ(mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data + mat2.data)
end

"""
    Base.:-(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S})

Operation `-` for two `gᵐᵃᵗ` objects.
"""
function Base.:-(mat1::gᵐᵃᵗ{S}, mat2::gᵐᵃᵗ{S}) where {S}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    gᵐᵃᵗ(mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data - mat2.data)
end

"""
    Base.:*(mat::gᵐᵃᵗ{S}, x)

Operation `*` for a `gᵐᵃᵗ` object and a scalar value.
"""
function Base.:*(mat::gᵐᵃᵗ{S}, x) where {S}
    cx = convert(S, x)
    gᵐᵃᵗ(mat.ntau, mat.ndim1, mat.ndim2, mat.data * cx)
end

"""
    Base.:*(x, mat::gᵐᵃᵗ{S})

Operation `*` for a scalar value and a `gᵐᵃᵗ` object.
"""
Base.:*(x, mat::gᵐᵃᵗ{S}) where {S} = Base.:*(mat, x)

#=
### *gᵐᵃᵗᵐ* : *Struct*
=#

"""
    gᵐᵃᵗᵐ{S}

Matsubara component (``G^M``) of contour Green's function at given time
step `tstp = 0`. It is designed for ``\tau < 0`` case. It is not an
independent component. It can be constructed from the `gᵐᵃᵗ{T}` struct.

See also: [`𝔾ʳᵉᵗ`](@ref), [`𝔾ˡᵐⁱˣ`](@ref), [`𝔾ˡᵉˢˢ`](@ref).
"""
mutable struct gᵐᵃᵗᵐ{S} <: CnAbstractVector{S}
    sign  :: I64 # Used to distinguish fermions and bosons
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataV :: Ref{gᵐᵃᵗ{S}}
end

#=
### *gᵐᵃᵗᵐ* : *Constructors*
=#

"""
    gᵐᵃᵗᵐ(sign::I64, mat::gᵐᵃᵗ{S})

Constructor. Note that the `matm` component is not independent. We use
the `mat` component to initialize it.
"""
function gᵐᵃᵗᵐ(sign::I64, mat::gᵐᵃᵗ{S}) where {S}
    # Sanity check
    @assert sign in (BOSE, FERMI)

    # Setup properties
    # Extract parameters from `mat`
    ntau = mat.ntau
    ndim1 = mat.ndim1
    ndim2 = mat.ndim2
    #
    # We don't allocate memory for `dataV` directly, but let it point to
    # the `mat` object.
    dataV = Ref(mat)

    # Call the default constructor
    gᵐᵃᵗᵐ(sign, ntau, ndim1, ndim2, dataV)
end

#=
### *gᵐᵃᵗᵐ* : *Indexing*
=#

"""
    Base.getindex(matm::gᵐᵃᵗᵐ{S}, ind::I64)

Visit the element stored in `gᵐᵃᵗᵐ` object.
"""
function Base.getindex(matm::gᵐᵃᵗᵐ{S}, ind::I64) where {S}
    # Sanity check
    @assert 1 ≤ ind ≤ matm.ntau

    # Return G^{M}(τᵢ < 0)
    matm.dataV[][matm.ntau - ind + 1] * matm.sign
end

#=
### *gʳᵉᵗ* : *Struct*
=#

"""
    gʳᵉᵗ{S}

Retarded component (``G^{R}``) of contour Green's function at given
time step `tstp`. Actually, it denotes ``G^{R}(tᵢ = tstp, tⱼ)``.

See also: [`gᵐᵃᵗ`](@ref), [`gˡᵐⁱˣ`](@ref), [`gˡᵉˢˢ`](@ref).
"""
mutable struct gʳᵉᵗ{S} <: CnAbstractVector{S}
    tstp  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{S}
end

#=
### *gʳᵉᵗ* : *Constructors*
=#

"""
    gʳᵉᵗ(tstp::I64, ndim1::I64, ndim2::I64, v::S) where {S}

Constructor. All the vector elements are set to be `v`.
"""
function gʳᵉᵗ(tstp::I64, ndim1::I64, ndim2::I64, v::S) where {S}
    # Sanity check
    @assert tstp ≥ 1
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create Element{S}
    element = fill(v, ndim1, ndim2)

    # Create VecArray{S}, whose size is indeed (tstp,).
    data = VecArray{S}(undef, tstp)
    for i = 1:tstp
        data[i] = copy(element)
    end

    # Call the default constructor
    gʳᵉᵗ(tstp, ndim1, ndim2, data)
end

"""
    gʳᵉᵗ(tstp::I64, ndim1::I64, ndim2::I64)

Constructor. All the vector elements are set to be `CZERO`.
"""
function gʳᵉᵗ(tstp::I64, ndim1::I64, ndim2::I64)
    gʳᵉᵗ(tstp, ndim1, ndim2, CZERO)
end

"""
    gʳᵉᵗ(tstp::I64, ndim1::I64)

Constructor. All the vector elements are set to be `CZERO`.
"""
function gʳᵉᵗ(tstp::I64, ndim1::I64)
    gʳᵉᵗ(tstp, ndim1, ndim1, CZERO)
end

"""
    gʳᵉᵗ(tstp::I64, x::Element{S})

Constructor. The vector is initialized by `x`.
"""
function gʳᵉᵗ(tstp::I64, x::Element{S}) where {S}
    # Sanity check
    @assert tstp ≥ 1

    ndim1, ndim2 = size(x)
    data = VecArray{S}(undef, tstp)
    for i = 1:tstp
        data[i] = copy(x)
    end

    # Call the default constructor
    gʳᵉᵗ(tstp, ndim1, ndim2, data)
end

#=
### *gʳᵉᵗ* : *Properties*
=#

"""
    getdims(ret::gʳᵉᵗ{S})

Return the dimensional parameters of contour function.

See also: [`gʳᵉᵗ`](@ref).
"""
function getdims(ret::gʳᵉᵗ{S}) where {S}
    return (ret.ndim1, ret.ndim2)
end

"""
    getsize(ret::gʳᵉᵗ{S})

Return the size of contour function.

See also: [`gʳᵉᵗ`](@ref).
"""
function getsize(ret::gʳᵉᵗ{S}) where {S}
    return ret.tstp
end

"""
    equaldims(ret::gʳᵉᵗ{S})

Return whether the dimensional parameters are equal.

See also: [`gʳᵉᵗ`](@ref).
"""
function equaldims(ret::gʳᵉᵗ{S}) where {S}
    return ret.ndim1 == ret.ndim2
end

"""
    iscompatible(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S})

Judge whether two `gʳᵉᵗ` objects are compatible.
"""
function iscompatible(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}) where {S}
    getsize(ret1) == getsize(ret2) &&
    getdims(ret1) == getdims(ret2)
end

"""
    iscompatible(ret1::gʳᵉᵗ{S}, ret2::𝔾ʳᵉᵗ{S})

Judge whether the `gʳᵉᵗ` and `𝔾ʳᵉᵗ` objects are compatible.
"""
function iscompatible(ret1::gʳᵉᵗ{S}, ret2::𝔾ʳᵉᵗ{S}) where {S}
    getsize(ret1) ≤ getsize(ret2) &&
    getdims(ret1) == getdims(ret2)
end

"""
    iscompatible(ret1::𝔾ʳᵉᵗ{S}, ret2::gʳᵉᵗ{S})

Judge whether the `gʳᵉᵗ` and `𝔾ʳᵉᵗ` objects are compatible.
"""
iscompatible(ret1::𝔾ʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}) where {S} = iscompatible(ret2, ret1)

"""
    iscompatible(C::Cn, ret::gʳᵉᵗ{S})

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `gʳᵉᵗ{S}` object).
"""
function iscompatible(C::Cn, ret::gʳᵉᵗ{S}) where {S}
    C.ntime ≥ getsize(ret) &&
    getdims(C) == getdims(ret)
end

"""
    iscompatible(ret::gʳᵉᵗ{S}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `gʳᵉᵗ{S}` object).
"""
iscompatible(ret::gʳᵉᵗ{S}, C::Cn) where {S} = iscompatible(C, ret)

"""
    distance(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S})

Calculate distance between two `gʳᵉᵗ` objects.
"""
function distance(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}) where {S}
    @assert iscompatible(ret1, ret2)

    err = 0.0
    #
    for m = 1:ret1.tstp
        err = err + abs(sum(ret1.data[m] - ret2.data[m]))
    end
    #
    return err
end

"""
    distance(ret1::gʳᵉᵗ{S}, ret2::𝔾ʳᵉᵗ{S}, tstp::I64)

Calculate distance between a `gʳᵉᵗ` object and a `𝔾ʳᵉᵗ` object at
given time step `tstp`.
"""
function distance(ret1::gʳᵉᵗ{S}, ret2::𝔾ʳᵉᵗ{S}, tstp::I64) where {S}
    @assert iscompatible(ret1, ret2)
    @assert ret1.tstp == tstp

    err = 0.0
    #
    for m = 1:ret1.tstp
        err = err + abs(sum(ret1.data[m] - ret2.data[tstp,m]))
    end
    #
    return err
end

"""
    distance(ret1::𝔾ʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}, tstp::I64)

Calculate distance between a `gʳᵉᵗ` object and a `𝔾ʳᵉᵗ` object at
given time step `tstp`.
"""
distance(ret1::𝔾ʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}, tstp::I64) where {S} = distance(ret2, ret1, tstp)

#=
### *gʳᵉᵗ* : *Indexing*
=#

"""
    Base.getindex(ret::gʳᵉᵗ{S}, j::I64)

Visit the element stored in `gʳᵉᵗ` object. Here `j` is index for
real times.
"""
function Base.getindex(ret::gʳᵉᵗ{S}, j::I64) where {S}
    # Sanity check
    @assert 1 ≤ j ≤ ret.tstp

    # Return G^{R}(tᵢ ≡ tstp, tⱼ)
    ret.data[j]
end

"""
    Base.getindex(ret::gʳᵉᵗ{S}, i::I64, tstp::I64)

Visit the element stored in `gʳᵉᵗ` object. Here `i` is index for
real times.
"""
function Base.getindex(ret::gʳᵉᵗ{S}, i::I64, tstp::I64) where {S}
    # Sanity check
    @assert tstp == ret.tstp
    @assert 1 ≤ i ≤ ret.tstp

    # Return G^{R}(tᵢ, tⱼ ≡ tstp)
    -(ret.data[j])'
end

"""
    Base.setindex!(ret::gʳᵉᵗ{S}, x::Element{S}, j::I64)

Setup the element in `gʳᵉᵗ` object.
"""
function Base.setindex!(ret::gʳᵉᵗ{S}, x::Element{S}, j::I64) where {S}
    # Sanity check
    @assert size(x) == getdims(ret)
    @assert 1 ≤ j ≤ ret.tstp

    # G^{R}(tᵢ ≡ tstp, tⱼ) = x
    ret.data[j] = copy(x)
end

"""
    Base.setindex!(ret::gʳᵉᵗ{S}, v::S, j::I64)

Setup the element in `gʳᵉᵗ` object.
"""
function Base.setindex!(ret::gʳᵉᵗ{S}, v::S, j::I64) where {S}
    # Sanity check
    @assert 1 ≤ j ≤ ret.tstp

    # G^{R}(tᵢ ≡ tstp, tⱼ) .= v
    fill!(ret.data[j], v)
end

#=
### *gʳᵉᵗ* : *Operations*
=#

"""
    memset!(ret::gʳᵉᵗ{S}, x)

Reset all the vector elements of `ret` to `x`. `x` should be a
scalar number.
"""
function memset!(ret::gʳᵉᵗ{S}, x) where {S}
    cx = convert(T, x)
    for i=1:ret.tstp
        fill!(ret.data[i], cx)
    end
end

"""
    zeros!(ret::gʳᵉᵗ{S})

Reset all the vector elements of `ret` to `ZERO`.
"""
zeros!(ret::gʳᵉᵗ{S}) where {S} = memset!(ret, zero(S))

"""
    memcpy!(src::gʳᵉᵗ{S}, dst::gʳᵉᵗ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::gʳᵉᵗ{S}, dst::gʳᵉᵗ{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::𝔾ʳᵉᵗ{S}, dst::gʳᵉᵗ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::𝔾ʳᵉᵗ{S}, dst::gʳᵉᵗ{S}) where {S}
    @assert iscompatible(src, dst)
    tstp = dst.tstp
    @. dst.data = copy(src.data[tstp,1:tstp])
end

"""
    memcpy!(src::gʳᵉᵗ{S}, dst::𝔾ʳᵉᵗ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::gʳᵉᵗ{S}, dst::𝔾ʳᵉᵗ{S}) where {S}
    @assert iscompatible(src, dst)
    tstp = src.tstp
    @. dst.data[tstp,1:tstp] = copy(src.data)
end

"""
    incr!(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}, alpha::S)

Add a `gʳᵉᵗ` with given weight (`alpha`) to another `gʳᵉᵗ`.
"""
function incr!(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}, alpha::S) where {S}
    @assert iscompatible(ret1, ret2)
    tstp = ret2.tstp
    for i = 1:tstp
        @. ret1.data[i] = ret1.data[i] + ret2.data[i] * alpha
    end
end

"""
    incr!(ret1::𝔾ʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}, alpha::S)

Add a `gʳᵉᵗ` with given weight (`alpha`) to a `𝔾ʳᵉᵗ`.
"""
function incr!(ret1::𝔾ʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}, alpha::S) where {S}
    @assert iscompatible(ret1, ret2)
    tstp = ret2.tstp
    for i = 1:tstp
        @. ret1.data[tstp,i] = ret1.data[tstp,i] + ret2.data[i] * alpha
    end
end

"""
    incr!(ret1::gʳᵉᵗ{S}, ret2::𝔾ʳᵉᵗ{S}, alpha::S)

Add a `𝔾ʳᵉᵗ` with given weight (`alpha`) to a `gʳᵉᵗ`.
"""
function incr!(ret1::gʳᵉᵗ{S}, ret2::𝔾ʳᵉᵗ{S}, alpha::S) where {S}
    @assert iscompatible(ret1, ret2)
    tstp = ret1.tstp
    for i = 1:tstp
        @. ret1.data[i] = ret1.data[i] + ret2.data[tstp,i] * alpha
    end
end

"""
    smul!(ret::gʳᵉᵗ{S}, alpha::S)

Multiply a `gʳᵉᵗ` with given weight (`alpha`).
"""
function smul!(ret::gʳᵉᵗ{S}, alpha::S) where {S}
    for i = 1:ret.tstp
        @. ret.data[i] = ret.data[i] * alpha
    end
end

"""
    smul!(x::Element{S}, ret::gʳᵉᵗ{S})

Left multiply a `gʳᵉᵗ` with given weight (`x`).
"""
function smul!(x::Element{S}, ret::gʳᵉᵗ{S}) where {S}
    for i = 1:ret.tstp
        ret.data[i] = x * ret.data[i]
    end
end

"""
    smul!(ret::gʳᵉᵗ{S}, x::Cf{S})

Right multiply a `gʳᵉᵗ` with given weight (`x`).
"""
function smul!(ret::gʳᵉᵗ{S}, x::Cf{S}) where {S}
    for i = 1:ret.tstp
        ret.data[i] = ret.data[i] * x[i]
    end
end

#=
### *gʳᵉᵗ* : *Traits*
=#

"""
    Base.:+(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S})

Operation `+` for two `gʳᵉᵗ` objects.
"""
function Base.:+(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}) where {S}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    gʳᵉᵗ(ret1.tstp, ret1.ndim1, ret1.ndim2, ret1.data + ret2.data)
end

"""
    Base.:-(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S})

Operation `-` for two `gʳᵉᵗ` objects.
"""
function Base.:-(ret1::gʳᵉᵗ{S}, ret2::gʳᵉᵗ{S}) where {S}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    gʳᵉᵗ(ret1.tstp, ret1.ndim1, ret1.ndim2, ret1.data - ret2.data)
end

"""
    Base.:*(ret::gʳᵉᵗ{S}, x)

Operation `*` for a `gʳᵉᵗ` object and a scalar value.
"""
function Base.:*(ret::gʳᵉᵗ{S}, x) where {S}
    cx = convert(S, x)
    gʳᵉᵗ(ret.tstp, ret.ndim1, ret.ndim2, ret.data * cx)
end

"""
    Base.:*(x, ret::gʳᵉᵗ{S})

Operation `*` for a scalar value and a `gʳᵉᵗ` object.
"""
Base.:*(x, ret::gʳᵉᵗ{S}) where {S} = Base.:*(ret, x)

#=
### *gᵃᵈᵛ* : *Struct*
=#

mutable struct gᵃᵈᵛ{S} <: CnAbstractVector{S} end

#=
### *gˡᵐⁱˣ* : *Struct*
=#

"""
    gˡᵐⁱˣ{S}

Left-mixing component (``G^{⌉}``) of contour Green's function at given
time step `tstp`. Actually, it denotes ``G^{⌉}(tᵢ ≡ tstp, τⱼ)``.

See also: [`gᵐᵃᵗ`](@ref), [`gʳᵉᵗ`](@ref), [`gˡᵉˢˢ`](@ref).
"""
mutable struct gˡᵐⁱˣ{S} <: CnAbstractVector{S}
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{S}
end

#=
### *gˡᵐⁱˣ* : *Constructors*
=#

"""
    gˡᵐⁱˣ(ntau::I64, ndim1::I64, ndim2::I64, v::S)

Constructor. All the matrix elements are set to be `v`.
"""
function gˡᵐⁱˣ(ntau::I64, ndim1::I64, ndim2::I64, v::S) where {S}
    # Sanity check
    @assert ntau ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create Element{S}
    element = fill(v, ndim1, ndim2)

    # Create VecArray{S}, whose size is indeed (ntau,).
    data = VecArray{S}(undef, ntau)
    for i = 1:ntau
        data[i] = copy(element)
    end

    # Call the default constructor
    gˡᵐⁱˣ(ntau, ndim1, ndim2, data)
end

"""
    gˡᵐⁱˣ(ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function gˡᵐⁱˣ(ntau::I64, ndim1::I64, ndim2::I64)
    gˡᵐⁱˣ(ntau, ndim1, ndim2, CZERO)
end

"""
    gˡᵐⁱˣ(ntau::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function gˡᵐⁱˣ(ntau::I64, ndim1::I64)
    gˡᵐⁱˣ(ntau, ndim1, ndim1, CZERO)
end

"""
    gˡᵐⁱˣ(ntau::I64, x::Element{S})

Constructor. The matrix is initialized by `x`.
"""
function gˡᵐⁱˣ(ntau::I64, x::Element{S}) where {S}
    # Sanity check
    @assert ntau ≥ 2

    ndim1, ndim2 = size(x)
    data = VecArray{S}(undef, ntau)
    for i = 1:ntau
        data[i] = copy(x)
    end

    # Call the default constructor
    gˡᵐⁱˣ(ntau, ndim1, ndim2, data)
end

#=
### *gˡᵐⁱˣ* : *Properties*
=#

"""
    getdims(lmix::gˡᵐⁱˣ{S})

Return the dimensional parameters of contour function.

See also: [`gˡᵐⁱˣ`](@ref).
"""
function getdims(lmix::gˡᵐⁱˣ{S}) where {S}
    return (lmix.ndim1, lmix.ndim2)
end

"""
    getsize(lmix::gˡᵐⁱˣ{S})

Return the size of contour function.

See also: [`gˡᵐⁱˣ`](@ref).
"""
function getsize(lmix::gˡᵐⁱˣ{S}) where {S}
    return lmix.ntau
end

"""
    equaldims(lmix::gˡᵐⁱˣ{S})

Return whether the dimensional parameters are equal.

See also: [`gˡᵐⁱˣ`](@ref).
"""
function equaldims(lmix::gˡᵐⁱˣ{S}) where {S}
    return lmix.ndim1 == lmix.ndim2
end

"""
    iscompatible(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S})

Judge whether two `gˡᵐⁱˣ` objects are compatible.
"""
function iscompatible(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}) where {S}
    getsize(lmix1) == getsize(lmix2) &&
    getdims(lmix1) == getdims(lmix2)
end

"""
    iscompatible(lmix1::gˡᵐⁱˣ{S}, lmix2::𝔾ˡᵐⁱˣ{S})

Judge whether the `gˡᵐⁱˣ` and `𝔾ˡᵐⁱˣ` objects are compatible.
"""
function iscompatible(lmix1::gˡᵐⁱˣ{S}, lmix2::𝔾ˡᵐⁱˣ{S}) where {S}
    getsize(lmix1) == lmix2.ntau &&
    getdims(lmix1) == getdims(lmix2)
end

"""
    iscompatible(lmix1::𝔾ˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S})

Judge whether the `gˡᵐⁱˣ` and `𝔾ˡᵐⁱˣ` objects are compatible.
"""
iscompatible(lmix1::𝔾ˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}) where {S} = iscompatible(lmix2, lmix1)

"""
    iscompatible(C::Cn, lmix::gˡᵐⁱˣ{S})

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `gˡᵐⁱˣ{S}` object).
"""
function iscompatible(C::Cn, lmix::gˡᵐⁱˣ{S}) where {S}
    C.ntau == getsize(lmix) &&
    getdims(C) == getdims(lmix)
end

"""
    iscompatible(lmix::gˡᵐⁱˣ{S}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `gˡᵐⁱˣ{S}` object).
"""
iscompatible(lmix::gˡᵐⁱˣ{S}, C::Cn) where {S} = iscompatible(C, lmix)

"""
    distance(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S})

Calculate distance between two `gˡᵐⁱˣ` objects.
"""
function distance(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}) where {S}
    @assert iscompatible(lmix1, lmix2)

    err = 0.0
    #
    for m = 1:lmix1.ntau
        err = err + abs(sum(lmix1.data[m] - lmix2.data[m]))
    end
    #
    return err
end

"""
    distance(lmix1::gˡᵐⁱˣ{S}, lmix2::𝔾ˡᵐⁱˣ{S}, tstp::I64)

Calculate distance between a `gˡᵐⁱˣ` object and a `𝔾ˡᵐⁱˣ` object at
given time step `tstp`.
"""
function distance(lmix1::gˡᵐⁱˣ{S}, lmix2::𝔾ˡᵐⁱˣ{S}, tstp::I64) where {S}
    @assert iscompatible(lmix1, lmix2)

    err = 0.0
    #
    for m = 1:lmix1.ntau
        err = err + abs(sum(lmix1.data[m] - lmix2.data[tstp,m]))
    end
    #
    return err
end

"""
    distance(lmix1::𝔾ˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}, tstp::I64)

Calculate distance between a `gˡᵐⁱˣ` object and a `𝔾ˡᵐⁱˣ` object at
given time step `tstp`.
"""
distance(lmix1::𝔾ˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}, tstp::I64) where {S} = distance(lmix2, lmix1, tstp)

#=
### *gˡᵐⁱˣ* : *Indexing*
=#

"""
    Base.getindex(lmix::gˡᵐⁱˣ{S}, j::I64)

Visit the element stored in `gˡᵐⁱˣ` object.
"""
function Base.getindex(lmix::gˡᵐⁱˣ{S}, j::I64) where {S}
    # Sanity check
    @assert 1 ≤ j ≤ lmix.ntau

    # Return G^{⌉}(tᵢ ≡ tstp, τⱼ)
    lmix.data[j]
end

"""
    Base.setindex!(lmix::gˡᵐⁱˣ{S}, x::Element{S}, j::I64)

Setup the element in `gˡᵐⁱˣ` object.
"""
function Base.setindex!(lmix::gˡᵐⁱˣ{S}, x::Element{S}, j::I64) where {S}
    # Sanity check
    @assert size(x) == getdims(lmix)
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ ≡ tstp, τⱼ) = x
    lmix.data[j] = copy(x)
end

"""
    Base.setindex!(lmix::gˡᵐⁱˣ{S}, v::S, j::I64)

Setup the element in `gˡᵐⁱˣ` object.
"""
function Base.setindex!(lmix::gˡᵐⁱˣ{S}, v::S, j::I64) where {S}
    # Sanity check
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ ≡ tstp, τⱼ) .= v
    fill!(lmix.data[j], v)
end

#=
### *gˡᵐⁱˣ* : *Operations*
=#

"""
    memset!(lmix::gˡᵐⁱˣ{S}, x)

Reset all the matrix elements of `lmix` to `x`. `x` should be a
scalar number.
"""
function memset!(lmix::gˡᵐⁱˣ{S}, x) where {S}
    cx = convert(S, x)
    for i=1:lmix.ntau
        fill!(lmix.data[i], cx)
    end
end

"""
    zeros!(lmix::gˡᵐⁱˣ{S})

Reset all the matrix elements of `lmix` to `ZERO`.
"""
zeros!(lmix::gˡᵐⁱˣ{S}) where {S} = memset!(lmix, zero(S))

"""
    memcpy!(src::gˡᵐⁱˣ{S}, dst::gˡᵐⁱˣ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::gˡᵐⁱˣ{S}, dst::gˡᵐⁱˣ{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::𝔾ˡᵐⁱˣ{S}, dst::gˡᵐⁱˣ{S}, tstp::I64)

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::𝔾ˡᵐⁱˣ{S}, dst::gˡᵐⁱˣ{S}, tstp::I64) where {S}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    @. dst.data = copy(src.data[tstp,:])
end

"""
    memcpy!(src::gˡᵐⁱˣ{S}, dst::𝔾ˡᵐⁱˣ{S}, tstp::I64)

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::gˡᵐⁱˣ{S}, dst::𝔾ˡᵐⁱˣ{S}, tstp::I64) where {S}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ dst.ntime
    @. dst.data[tstp,:] = copy(src.data)
end

"""
    incr!(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}, alpha::S)

Add a `gˡᵐⁱˣ` with given weight (`alpha`) to another `gˡᵐⁱˣ`.
"""
function incr!(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}, alpha::S) where {S}
    @assert iscompatible(lmix1, lmix2)
    for i = 1:lmix2.ntau
        @. lmix1.data[i] = lmix1.data[i] + lmix2.data[i] * alpha
    end
end

"""
    incr!(lmix1::𝔾ˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}, tstp::I64, alpha::S)

Add a `gˡᵐⁱˣ` with given weight (`alpha`) to a `𝔾ˡᵐⁱˣ`.
"""
function incr!(lmix1::𝔾ˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}, tstp::I64, alpha::S) where {S}
    @assert iscompatible(lmix1, lmix2)
    @assert 1 ≤ tstp ≤ lmix1.ntime
    for i = 1:lmix2.ntau
        @. lmix1.data[tstp,i] = lmix1.data[tstp,i] + lmix2.data[i] * alpha
    end
end

"""
    incr!(lmix1::gˡᵐⁱˣ{S}, lmix2::𝔾ˡᵐⁱˣ{S}, tstp::I64, alpha::S)

Add a `𝔾ˡᵐⁱˣ` with given weight (`alpha`) to a `gˡᵐⁱˣ`.
"""
function incr!(lmix1::gˡᵐⁱˣ{S}, lmix2::𝔾ˡᵐⁱˣ{S}, tstp::I64, alpha::S) where {S}
    @assert iscompatible(lmix1, lmix2)
    @assert 1 ≤ tstp ≤ lmix2.ntime
    for i = 1:lmix1.ntau
        @. lmix1.data[i] = lmix1.data[i] + lmix2.data[tstp,i] * alpha
    end
end

"""
    smul!(lmix::gˡᵐⁱˣ{S}, alpha::S)

Multiply a `gˡᵐⁱˣ` with given weight (`alpha`).
"""
function smul!(lmix::gˡᵐⁱˣ{S}, alpha::S) where {S}
    for i = 1:lmix.ntau
        @. lmix.data[i] = lmix.data[i] * alpha
    end
end

"""
    smul!(x::Element{S}, lmix::gˡᵐⁱˣ{S})

Left multiply a `gˡᵐⁱˣ` with given weight (`x`).
"""
function smul!(x::Element{S}, lmix::gˡᵐⁱˣ{S}) where {S}
    for i = 1:lmix.ntau
        lmix.data[i] = x * lmix.data[i]
    end
end

"""
    smul!(lmix::gˡᵐⁱˣ{S}, x::Element{S})

Right multiply a `gˡᵐⁱˣ` with given weight (`x`).
"""
function smul!(lmix::gˡᵐⁱˣ{S}, x::Element{S}) where {S}
    for i = 1:lmix.ntau
        lmix.data[i] = lmix.data[i] * x
    end
end

#=
### *gˡᵐⁱˣ* : *Traits*
=#

"""
    Base.:+(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S})

Operation `+` for two `gˡᵐⁱˣ` objects.
"""
function Base.:+(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}) where {S}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    gˡᵐⁱˣ(lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data + lmix2.data)
end

"""
    Base.:-(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S})

Operation `-` for two `gˡᵐⁱˣ` objects.
"""
function Base.:-(lmix1::gˡᵐⁱˣ{S}, lmix2::gˡᵐⁱˣ{S}) where {S}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    gˡᵐⁱˣ(lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data - lmix2.data)
end

"""
    Base.:*(lmix::gˡᵐⁱˣ{S}, x)

Operation `*` for a `gˡᵐⁱˣ` object and a scalar value.
"""
function Base.:*(lmix::gˡᵐⁱˣ{S}, x) where {S}
    cx = convert(S, x)
    gˡᵐⁱˣ(lmix.ntau, lmix.ndim1, lmix.ndim2, lmix.data * cx)
end

"""
    Base.:*(x, lmix::gˡᵐⁱˣ{S})

Operation `*` for a scalar value and a `gˡᵐⁱˣ` object.
"""
Base.:*(x, lmix::gˡᵐⁱˣ{S}) where {S} = Base.:*(lmix, x)

#=
### *gʳᵐⁱˣ* : *Struct*
=#

"""
    gʳᵐⁱˣ{S}

Right-mixing component (``G^{⌈}``) of contour Green's function at given
time step `tstp`. Actually, it denotes ``G^{⌈}(τᵢ, tⱼ ≡ tstp)``

See also: [`gᵐᵃᵗ`](@ref), [`gʳᵉᵗ`](@ref), [`gˡᵉˢˢ`](@ref).
"""
mutable struct gʳᵐⁱˣ{S} <: CnAbstractVector{S}
    sign  :: I64 # Used to distinguish fermions and bosons
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataL :: Ref{gˡᵐⁱˣ{S}}
end

#=
### *gʳᵐⁱˣ* : *Constructors*
=#

"""
    gʳᵐⁱˣ(sign::I64, lmix::gˡᵐⁱˣ{S})

Constructor. Note that the `rmix` component is not independent. We use
the `lmix` component to initialize it.
"""
function gʳᵐⁱˣ(sign::I64, lmix::gˡᵐⁱˣ{S}) where {S}
    # Sanity check
    @assert sign in (BOSE, FERMI)

    # Setup properties
    # Extract parameters from `lmix`
    ntau  = lmix.ntau
    ndim1 = lmix.ndim1
    ndim2 = lmix.ndim2
    #
    # We don't allocate memory for `dataL` directly, but let it point to
    # the `lmix` object.
    dataL = Ref(lmix)

    # Call the default constructor
    gʳᵐⁱˣ(sign, ntau, ndim1, ndim2, dataL)
end

#=
### *gʳᵐⁱˣ* : *Indexing*
=#

"""
    Base.getindex(rmix::gʳᵐⁱˣ{S}, i::I64)

Visit the element stored in `gʳᵐⁱˣ` object.
"""
function Base.getindex(rmix::gʳᵐⁱˣ{S}, i::I64) where {S}
    # Sanity check
    @assert 1 ≤ i ≤ rmix.ntau

    # Return G^{⌈}(τᵢ, tⱼ ≡ tstp)
    (rmix.dataL[])[rmix.ntau - i + 1]' * (-rmix.sign)
end

#=
### *gˡᵉˢˢ* : *Struct*
=#

"""
    gˡᵉˢˢ{S}

Lesser component (``G^{<}``) of contour Green's function at given
time step `tstp`. Actually, it denotes ``G^{<}(tᵢ, tⱼ ≡ tstp)``.
"""
mutable struct gˡᵉˢˢ{S} <: CnAbstractVector{S}
    tstp  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{S}
end

#=
### *gˡᵉˢˢ* : *Constructors*
=#

"""
    gˡᵉˢˢ(tstp::I64, ndim1::I64, ndim2::I64, v::S)

Constructor. All the matrix elements are set to be `v`.
"""
function gˡᵉˢˢ(tstp::I64, ndim1::I64, ndim2::I64, v::S) where {S}
    # Sanity check
    @assert tstp ≥ 1
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create Element{S}
    element = fill(v, ndim1, ndim2)

    # Create VecArray{S}, whose size is indeed (tstp,).
    data = VecArray{S}(undef, tstp)
    for i = 1:tstp
        data[i] = copy(element)
    end

    # Call the default constructor
    gˡᵉˢˢ(tstp, ndim1, ndim2, data)
end

"""
    gˡᵉˢˢ(tstp::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function gˡᵉˢˢ(tstp::I64, ndim1::I64, ndim2::I64)
    gˡᵉˢˢ(tstp, ndim1, ndim2, CZERO)
end

"""
    gˡᵉˢˢ(tstp::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function gˡᵉˢˢ(tstp::I64, ndim1::I64)
    gˡᵉˢˢ(tstp, ndim1, ndim1, CZERO)
end

"""
    gˡᵉˢˢ(tstp::I64, x::Element{S})

Constructor. The matrix is initialized by `x`.
"""
function gˡᵉˢˢ(tstp::I64, x::Element{S}) where {S}
    # Sanity check
    @assert tstp ≥ 1

    ndim1, ndim2 = size(x)
    data = VecArray{S}(undef, tstp)
    for i = 1:tstp
        data[i] = copy(x)
    end

    # Call the default constructor
    gˡᵉˢˢ(tstp, ndim1, ndim2, data)
end

#=
### *gˡᵉˢˢ* : *Properties*
=#

"""
    getdims(less::gˡᵉˢˢ{S})

Return the dimensional parameters of contour function.

See also: [`gˡᵉˢˢ`](@ref).
"""
function getdims(less::gˡᵉˢˢ{S}) where {S}
    return (less.ndim1, less.ndim2)
end

"""
    getsize(less::gˡᵉˢˢ{S})

Return the size of contour function.

See also: [`gˡᵉˢˢ`](@ref).
"""
function getsize(less::gˡᵉˢˢ{S}) where {S}
    return less.tstp
end

"""
    equaldims(less::gˡᵉˢˢ{S})

Return whether the dimensional parameters are equal.

See also: [`gˡᵉˢˢ`](@ref).
"""
function equaldims(less::gˡᵉˢˢ{S}) where {S}
    return less.ndim1 == less.ndim2
end

"""
    iscompatible(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S})

Judge whether two `gˡᵉˢˢ` objects are compatible.
"""
function iscompatible(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}) where {S}
    getsize(less1) == getsize(less2) &&
    getdims(less1) == getdims(less2)
end

"""
    iscompatible(less1::gˡᵉˢˢ{S}, less2::𝔾ˡᵉˢˢ{S})

Judge whether the `gˡᵉˢˢ` and `𝔾ˡᵉˢˢ` objects are compatible.
"""
function iscompatible(less1::gˡᵉˢˢ{S}, less2::𝔾ˡᵉˢˢ{S}) where {S}
    getsize(less1) ≤ getsize(less2) &&
    getdims(less1) == getdims(less2)
end

"""
    iscompatible(less1::𝔾ˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S})

Judge whether the `gˡᵉˢˢ` and `𝔾ˡᵉˢˢ` objects are compatible.
"""
iscompatible(less1::𝔾ˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}) where {S} = iscompatible(less2, less1)

"""
    iscompatible(C::Cn, less::gˡᵉˢˢ{S})

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `gˡᵉˢˢ{S}` object).
"""
function iscompatible(C::Cn, less::gˡᵉˢˢ{S}) where {S}
    C.ntime ≥ getsize(less) &&
    getdims(C) == getdims(less)
end

"""
    iscompatible(less::gˡᵉˢˢ{S}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `gˡᵉˢˢ{S}` object).
"""
iscompatible(less::gˡᵉˢˢ{S}, C::Cn) where {S} = iscompatible(C, less)

"""
    distance(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S})

Calculate distance between two `gˡᵉˢˢ` objects.
"""
function distance(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}) where {S}
    @assert iscompatible(less1, less2)

    err = 0.0
    #
    for m = 1:less1.tstp
        err = err + abs(sum(less1.data[m] - less2.data[m]))
    end
    #
    return err
end

"""
    distance(less1::gˡᵉˢˢ{S}, less2::𝔾ˡᵉˢˢ{S}, tstp::I64)

Calculate distance between a `gˡᵉˢˢ` object and a `𝔾ˡᵉˢˢ` object at
given time step `tstp`.
"""
function distance(less1::gˡᵉˢˢ{S}, less2::𝔾ˡᵉˢˢ{S}, tstp::I64) where {S}
    @assert iscompatible(less1, less2)
    @assert tstp == less1.tstp

    err = 0.0
    #
    for m = 1:less1.tstp
        err = err + abs(sum(less1.data[m] - less2.data[m,tstp]))
    end
    #
    return err
end

"""
    distance(less1::𝔾ˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}, tstp::I64)

Calculate distance between a `gˡᵉˢˢ` object and a `𝔾ˡᵉˢˢ` object at
given time step `tstp`.
"""
distance(less1::𝔾ˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}, tstp::I64) where {S} = distance(less2, less1, tstp)

#=
### *gˡᵉˢˢ* : *Indexing*
=#

"""
    Base.getindex(less::gˡᵉˢˢ{S}, i::I64)

Visit the element stored in `gˡᵉˢˢ` object.
"""
function Base.getindex(less::gˡᵉˢˢ{S}, i::I64) where {S}
    # Sanity check
    @assert 1 ≤ i ≤ less.tstp

    # Return G^{<}(tᵢ, tⱼ ≡ tstp)
    less.data[i]
end

"""
    Base.getindex(less::gˡᵉˢˢ{S}, tstp::I64, j::I64)

Visit the element stored in `gˡᵉˢˢ` object.
"""
function Base.getindex(less::gˡᵉˢˢ{S}, tstp::I64, j::I64) where {S}
    # Sanity check
    @assert tstp == less.tstp
    @assert 1 ≤ j ≤ less.tstp

    # Return G^{<}(tᵢ ≡ tstp, tⱼ)
    -(less.data[i])'
end

"""
    Base.setindex!(less::gˡᵉˢˢ{S}, x::Element{S}, i::I64)

Setup the element in `gˡᵉˢˢ` object.
"""
function Base.setindex!(less::gˡᵉˢˢ{S}, x::Element{S}, i::I64) where {S}
    # Sanity check
    @assert size(x) == getdims(less)
    @assert 1 ≤ i ≤ less.tstp

    # G^{<}(tᵢ, tⱼ ≡ tstp) = x
    less.data[i] = copy(x)
end

"""
    Base.setindex!(less::gˡᵉˢˢ{S}, v::S, i::I64)

Setup the element in `gˡᵉˢˢ` object.
"""
function Base.setindex!(less::gˡᵉˢˢ{S}, v::S, i::I64) where {S}
    # Sanity check
    @assert 1 ≤ i ≤ less.tstp

    # G^{<}(tᵢ, tⱼ ≡ tstp) .= v
    fill!(less.data[i], v)
end

#=
### *gˡᵉˢˢ* : *Operations*
=#

"""
    memset!(less::gˡᵉˢˢ{S}, x)

Reset all the matrix elements of `less` to `x`. `x` should be a
scalar number.
"""
function memset!(less::gˡᵉˢˢ{S}, x) where {S}
    cx = convert(S, x)
    for i=1:less.tstp
        fill!(less.data[i], cx)
    end
end

"""
    zeros!(less::gˡᵉˢˢ{S})

Reset all the matrix elements of `less` to `ZERO`.
"""
zeros!(less::gˡᵉˢˢ{S}) where {S} = memset!(less, zero(S))

"""
    memcpy!(src::gˡᵉˢˢ{S}, dst::gˡᵉˢˢ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::gˡᵉˢˢ{S}, dst::gˡᵉˢˢ{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::𝔾ˡᵉˢˢ{S}, dst::gˡᵉˢˢ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::𝔾ˡᵉˢˢ{S}, dst::gˡᵉˢˢ{S}) where {S}
    @assert iscompatible(src, dst)
    tstp = dst.tstp
    @. dst.data = copy(src.data[1:tstp,tstp])
end

"""
    memcpy!(src::gˡᵉˢˢ{S}, dst::𝔾ˡᵉˢˢ{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::gˡᵉˢˢ{S}, dst::𝔾ˡᵉˢˢ{S}) where {S}
    @assert iscompatible(src, dst)
    tstp = src.tstp
    @. dst.data[1:tstp,tstp] = copy(src.data)
end

"""
    incr!(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}, alpha::S)

Add a `gˡᵉˢˢ` with given weight (`alpha`) to another `gˡᵉˢˢ`.
"""
function incr!(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}, alpha::S) where {S}
    @assert iscompatible(less1, less2)
    tstp = less2.tstp
    for i = 1:tstp
        @. less1.data[i] = less1.data[i] + less2.data[i] * alpha
    end
end

"""
    incr!(less1::𝔾ˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}, alpha::S)

Add a `gˡᵉˢˢ` with given weight (`alpha`) to a `𝔾ˡᵉˢˢ`.
"""
function incr!(less1::𝔾ˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}, alpha::S) where {S}
    @assert iscompatible(less1, less2)
    tstp = less2.tstp
    for i = 1:tstp
        @. less1.data[i,tstp] = less1.data[i,tstp] + less2.data[i] * alpha
    end
end

"""
    incr!(less1::gˡᵉˢˢ{S}, less2::𝔾ˡᵉˢˢ{S}, alpha::S)

Add a `𝔾ˡᵉˢˢ` with given weight (`alpha`) to a `gˡᵉˢˢ`.
"""
function incr!(less1::gˡᵉˢˢ{S}, less2::𝔾ˡᵉˢˢ{S}, alpha::S) where {S}
    @assert iscompatible(less1, less2)
    tstp = less1.tstp
    for i = 1:tstp
        @. less1.data[i] = less1.data[i] + less2.data[i,tstp] * alpha
    end
end

"""
    smul!(less::gˡᵉˢˢ{S}, alpha::S)

Multiply a `gˡᵉˢˢ` with given weight (`alpha`).
"""
function smul!(less::gˡᵉˢˢ{S}, alpha::S) where {S}
    for i = 1:less.tstp
        @. less.data[i] = less.data[i] * alpha
    end
end

"""
    smul!(x::Cf{S}, less::gˡᵉˢˢ{S})

Left multiply a `gˡᵉˢˢ` with given weight (`x`).
"""
function smul!(x::Cf{S}, less::gˡᵉˢˢ{S}) where {S}
    for i = 1:less.tstp
        less.data[i] = x[i] * less.data[i]
    end
end

"""
    smul!(less::gˡᵉˢˢ{S}, x::Element{S})

Right multiply a `gˡᵉˢˢ` with given weight (`x`).
"""
function smul!(less::gˡᵉˢˢ{S}, x::Element{S}) where {S}
    for i = 1:less.tstp
        less.data[i] = less.data[i] * x
    end
end

#=
### *gˡᵉˢˢ* : *Traits*
=#

"""
    Base.:+(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S})

Operation `+` for two `gˡᵉˢˢ` objects.
"""
function Base.:+(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}) where {S}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    gˡᵉˢˢ(less1.tstp, less1.ndim1, less1.ndim2, less1.data + less2.data)
end

"""
    Base.:-(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S})

Operation `-` for two `gˡᵉˢˢ` objects.
"""
function Base.:-(less1::gˡᵉˢˢ{S}, less2::gˡᵉˢˢ{S}) where {S}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    gˡᵉˢˢ(less1.tstp, less1.ndim1, less1.ndim2, less1.data - less2.data)
end

"""
    Base.:*(less::gˡᵉˢˢ{S}, x)

Operation `*` for a `gˡᵉˢˢ` object and a scalar value.
"""
function Base.:*(less::gˡᵉˢˢ{S}, x) where {S}
    cx = convert(S, x)
    gˡᵉˢˢ(less.tstp, less.ndim1, less.ndim2, less.data * cx)
end

"""
    Base.:*(x, less::gˡᵉˢˢ{S})

Operation `*` for a scalar value and a `gˡᵉˢˢ` object.
"""
Base.:*(x, less::gˡᵉˢˢ{S}) where {S} = Base.:*(less, x)

#=
### *gᵍᵗʳ* : *Struct*
=#

"""
    gᵍᵗʳ{S}

Greater component (``G^{>}``) of contour Green's function at given
time step `tstp`.

See also: [`gʳᵉᵗ`](@ref), [`gˡᵐⁱˣ`](@ref), [`gˡᵉˢˢ`](@ref).
"""
mutable struct gᵍᵗʳ{S} <: CnAbstractVector{S}
    tstp  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataL :: Ref{gˡᵉˢˢ{S}}
    dataR :: Ref{gʳᵉᵗ{S}}
end

#=
### *gᵍᵗʳ* : *Constructors*
=#

"""
    gᵍᵗʳ(less::gˡᵉˢˢ{S}, ret::gʳᵉᵗ{S})

Constructor. Note that the `gtr` component is not independent. We use
the `less` and `ret` components to initialize it.
"""
function gᵍᵗʳ(less::gˡᵉˢˢ{S}, ret::gʳᵉᵗ{S}) where {S}
    # Setup properties
    # Extract parameters from `less`
    tstp  = less.tstp
    ndim1 = less.ndim1
    ndim2 = less.ndim2
    #
    # We don't allocate memory for `dataL` and `dataR` directly, but
    # let them point to  `less` and `ret` objects, respectively.
    dataL = Ref(less)
    dataR = Ref(ret)

    # Call the default constructor
    gᵍᵗʳ(tstp, ndim1, ndim2, dataL, dataR)
end

#=
### *gᵍᵗʳ* : *Indexing*
=#

"""
    Base.getindex(gtr::gᵍᵗʳ{S}, i::I64)

Visit the element stored in `gᵍᵗʳ` object.
"""
function Base.getindex(gtr::gᵍᵗʳ{S}, i::I64) where {S}
    # Sanity check
    @assert 1 ≤ i ≤ gtr.tstp

    # Return G^{>}(tᵢ, tⱼ ≡ tstp)
    gtr.dataL[][i] + gtr.dataR[][i, gtr.tstp]
end

"""
    Base.getindex(gtr::gᵍᵗʳ{S}, tstp::I64, j::I64)

Visit the element stored in `gᵍᵗʳ` object.
"""
function Base.getindex(gtr::gᵍᵗʳ{S}, tstp::I64, j::I64) where {S}
    # Sanity check
    @assert tstp == gtr.tstp
    @assert 1 ≤ j ≤ gtr.tstp

    # Return G^{>}(tᵢ ≡ tstp, tⱼ)
    gtr.dataL[][tstp, j] + gtr.dataR[][j]
end

#=
*Full Contour Green's Functions at Given Time Step `tstp`* :

In general, it can be viewed as a slice of the contour Green's function
at time axis. It includes four independent components.

* ``G^{M}(\tau)``
* ``G^{R}(t_i \equiv tstp, t_j)``, where ``t_j \le tstp``
* ``G^{⌉}(t_i \equiv tstp, \tau_j)``
* ``G^{<}(t_i, t_j \equiv tstp)``, where ``t_i \le tstp``

We also name them as `mat`, `ret`, `lmix`, and `less`, respectively.
=#

#=
### *𝒻* : *Struct*
=#

"""
    𝒻{S}

Standard contour-ordered Green's function at given time step `tstp`. It
includes four independent components, namely `mat`, `ret`, `lmix`, and
`less`. If `tstp = 0`, it denotes the equilibrium state (only the `mat`
component is valid). On the other hand, `tstp > 0` means nonequilibrium
state.
"""
mutable struct 𝒻{S} <: CnAbstractFunction{S}
    sign :: I64 # Used to distinguish fermions and bosons
    tstp :: I64
    mat  :: gᵐᵃᵗ{S}
    ret  :: gʳᵉᵗ{S}
    lmix :: gˡᵐⁱˣ{S}
    less :: gˡᵉˢˢ{S}
end

#=
### *𝒻* : *Constructors*
=#

"""
    𝒻(C::Cn, tstp::I64, v::S, sign::I64 = FERMI)

Standard constructor. This function is initialized by `v`.
"""
function 𝒻(C::Cn, tstp::I64, v::S, sign::I64 = FERMI) where {S}
    # Sanity check
    @assert sign in (BOSE, FERMI)
    @assert C.ntime ≥ tstp ≥ 0

    # Create mat, ret, lmix, and less.
    mat = gᵐᵃᵗ(C.ntau, C.ndim1, C.ndim2, v)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        ret = gʳᵉᵗ(tstp + 1, C.ndim1, C.ndim2, v)
    else
        ret = gʳᵉᵗ(tstp, C.ndim1, C.ndim2, v)
    end
    #
    lmix = gˡᵐⁱˣ(C.ntau, C.ndim1, C.ndim2, v)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        less = gˡᵉˢˢ(tstp + 1, C.ndim1, C.ndim2, v)
    else
        less = gˡᵉˢˢ(tstp, C.ndim1, C.ndim2, v)
    end

    # Call the default constructor
    𝒻(sign, tstp, mat, ret, lmix, less)
end

"""
    𝒻(C::Cn, tstp::I64, sign::I64 = FERMI)

Constructor. Create a fermionic contour function with zero initial values.
"""
function 𝒻(C::Cn, tstp::I64, sign::I64 = FERMI)
    # Sanity check
    @assert sign in (BOSE, FERMI)
    @assert C.ntime ≥ tstp ≥ 0

    # Create mat, ret, lmix, and less.
    mat = gᵐᵃᵗ(C.ntau, C.ndim1, C.ndim2)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        ret = gʳᵉᵗ(tstp + 1, C.ndim1, C.ndim2)
    else
        ret = gʳᵉᵗ(tstp, C.ndim1, C.ndim2)
    end
    #
    lmix = gˡᵐⁱˣ(C.ntau, C.ndim1, C.ndim2)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        less = gˡᵉˢˢ(tstp + 1, C.ndim1, C.ndim2)
    else
        less = gˡᵉˢˢ(tstp, C.ndim1, C.ndim2)
    end

    # Call the default constructor
    𝒻(sign, tstp, mat, ret, lmix, less)
end

"""
    𝒻(tstp::I64, ntau::I64, ndim1::I64, ndim2::I64, sign::I64 = FERMI)

Constructor. Create a fermionic contour function with zero initial values.
"""
function 𝒻(tstp::I64, ntau::I64, ndim1::I64, ndim2::I64, sign::I64 = FERMI)
    # Sanity check
    @assert sign in (BOSE, FERMI)
    @assert tstp ≥ 0
    @assert ntau ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create mat, ret, lmix, and less.
    mat = gᵐᵃᵗ(ntau, ndim1, ndim2)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        ret = gʳᵉᵗ(tstp + 1, ndim1, ndim2)
    else
        ret = gʳᵉᵗ(tstp, ndim1, ndim2)
    end
    #
    lmix = gˡᵐⁱˣ(ntau, ndim1, ndim2)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        less = gˡᵉˢˢ(tstp + 1, ndim1, ndim2)
    else
        less = gˡᵉˢˢ(tstp, ndim1, ndim2)
    end

    # Call the default constructor
    𝒻(sign, tstp, mat, ret, lmix, less)
end

#=
### *𝒻* : *Properties*
=#

"""
    getdims(cfv::𝒻{S})

Return the dimensional parameters of contour Green's function.

See also: [`𝒻`](@ref).
"""
function getdims(cfv::𝒻{S}) where {S}
    return getdims(cfv.less)
end

"""
    getntau(cfv::𝒻{S})

Return the `ntau` parameter of contour Green's function.
"""
function getntau(cfv::𝒻{S}) where {S}
    return getsize(cfv.mat)
end

"""
    gettstp(cfv::𝒻{S})

Return the `tstp` parameter of contour Green's function.
"""
function gettstp(cfv::𝒻{S}) where {S}
    return cfv.tstp # getsize(cfv.less) is wrong when cfv.tstp = 0!
end

"""
    getsign(cfv::𝒻{S})

Return the `sign` parameter of contour Green's function.
"""
function getsign(cfv::𝒻{S}) where {S}
    return cfv.sign
end

"""
    equaldims(cfv::𝒻{S})

Return whether the dimensional parameters are equal.

See also: [`𝒻`](@ref).
"""
function equaldims(cfv::𝒻{S}) where {S}
    return equaldims(cfv.less)
end

"""
    density(cfv::𝒻{S}, tstp::I64)

Returns the density matrix at given time step `tstp`. If `tstp = 0`,
it denotes the equilibrium state. However, when `tstp > 0`, it means
the nonequilibrium state.

See also: [`gᵐᵃᵗ`](@ref), [`gˡᵉˢˢ`](@ref).
"""
function density(cfv::𝒻{S}, tstp::I64) where {S}
    # Sanity check
    @assert tstp == gettstp(cfv)

    if tstp == 0
        return -cfv.mat[getntau(cfv)]
    else
        return cfv.less[tstp] * getsign(cfv) * CZI
    end
end

"""
    distance(cfv1::𝒻{S}, cfv2::𝒻{S}, tstp::I64)

Calculate distance between two `𝒻` objects at given time step `tstp`.
"""
function distance(cfv1::𝒻{S}, cfv2::𝒻{S}, tstp::I64) where {S}
    # Sanity check
    @assert tstp == gettstp(cfv1)

    err = 0.0
    #
    if tstp == 0
        err = err + distance(cfv1.mat, cfv2.mat)
    else
        err = err + distance(cfv1.ret, cfv2.ret)
        err = err + distance(cfv1.lmix, cfv2.lmix)
        err = err + distance(cfv1.less, cfv2.less)
    end
    #
    return err
end

"""
    distance(cfv1::𝒻{S}, cfm2::ℱ{S}, tstp::I64)

Calculate distance between a `𝒻` object and a `ℱ` object at
given time step `tstp`.
"""
function distance(cfv1::𝒻{S}, cfm2::ℱ{S}, tstp::I64) where {S}
    # Sanity check
    @assert tstp == gettstp(cfv1)

    err = 0.0
    #
    if tstp == 0
        err = err + distance(cfv1.mat, cfm2.mat)
    else
        err = err + distance(cfv1.ret, cfm2.ret, tstp)
        err = err + distance(cfv1.lmix, cfm2.lmix, tstp)
        err = err + distance(cfv1.less, cfm2.less, tstp)
    end
    #
    return err
end

"""
    distance(cfm1::ℱ{S}, cfv2::𝒻{S}, tstp::I64)

Calculate distance between a `𝒻` object and a `ℱ` object at
given time step `tstp`.
"""
distance(cfm1::ℱ{S}, cfv2::𝒻{S}, tstp::I64) where {S} = distance(cfv2, cfm1, tstp)

#=
### *𝒻* : *Indexing*
=#

"""
    Base.getindex(cfm::ℱ{T}, tstp::I64)

Return contour Green's function at given time step `tstp`.

See also: [`ℱ`](@ref), [`𝒻`](@ref).
"""
function Base.getindex(cfm::ℱ{T}, tstp::I64) where {T}
    # Sanity check
    @assert getntime(cfm) ≥ tstp ≥ 0

    # Get key parameters
    sign = getsign(cfm)
    ntau = getntau(cfm)
    ndim1, ndim2 = getdims(cfm)

    # Construct an empty `𝒻` struct
    cfv = 𝒻(tstp, ntau, ndim1, ndim2, sign)

    # Extract data at time step `tstp` from `ℱ` object, then copy
    # them to `𝒻` object.
    memcpy!(cfm, cfv)

    # Return the desired struct
    return cfv
end

"""
    Base.setindex!(cfm::ℱ{S}, cfv::𝒻{S}, tstp::I64)

Setup contout Green's function at given time step `tstp`.

See also: [`ℱ`](@ref), [`𝒻`](@ref).
"""
function Base.setindex!(cfm::ℱ{S}, cfv::𝒻{S}, tstp::I64) where {S}
    # Sanity check
    @assert tstp == gettstp(cfv)
    @assert 0 ≤ tstp ≤ getntime(cfm)

    # Copy data from `𝒻` object to `ℱ` object
    memcpy!(cfv, cfm)
end

#=
### *𝒻* : *Operations*
=#

"""
    memset!(cfv::𝒻{S}, x)

Reset all the matrix elements of `cfv` to `x`. `x` should be a
scalar number.
"""
function memset!(cfv::𝒻{S}, x) where {S}
    memset!(cfv.mat, x)
    memset!(cfv.ret, x)
    memset!(cfv.lmix, x)
    memset!(cfv.less, x)
end

"""
    memset!(cfv::𝒻{S}, tstp::I64, x)

Reset all the matrix elements of `cfv` to `x`. `x` should be a
scalar number. If `tstp = 0`, only the `mat` component is updated.
On the other hand, if `tstp > 0`, the `ret`, `lmix`, and `less`
components will be updated.
"""
function memset!(cfv::𝒻{S}, tstp::I64, x) where {S}
    @assert tstp == gettstp(cfv)
    if tstp > 0
        memset!(cfv.ret, x)
        memset!(cfv.lmix, x)
        memset!(cfv.less, x)
    else
        memset!(cfv.mat, x)
    end
end

"""
    zeros!(cfv::𝒻{S})

Reset all the matrix elements of `cfv` to `ZERO`.
"""
zeros!(cfv::𝒻{S}) where {S} = memset!(cfv, zero(S))

"""
    zeros!(cfv::𝒻{S}, tstp::I64)

Reset all the matrix elements of `cfv` to `ZERO` at given time step `tstp`.
"""
zeros!(cfv::𝒻{S}, tstp::I64) where {S} = memset!(cfv, tstp, zero(S))

"""
    memcpy!(src::𝒻{S}, dst::𝒻{S}, tstp::I64)

Extract data from a `𝒻` object (at given time step `tstp`), then
copy them to another `𝒻` object.

See also: [`𝒻`](@ref).
"""
function memcpy!(src::𝒻{S}, dst::𝒻{S}, tstp::I64) where {S}
    @assert tstp == gettstp(src)
    if tstp > 0
        memcpy!(src.ret, dst.ret)
        memcpy!(src.lmix, dst.lmix)
        memcpy!(src.less, dst.less)
    else
        memcpy!(src.mat, dst.mat)
    end
end

"""
    memcpy!(cfm::ℱ{S}, cfv::𝒻{S}, tstp::I64)

Extract data from a `ℱ` object (at given time step `tstp`), then
copy them to a `𝒻` object.

See also: [`ℱ`](@ref), [`𝒻`](@ref).
"""
function memcpy!(cfm::ℱ{S}, cfv::𝒻{S}, tstp::I64) where {S}
    @assert tstp == gettstp(cfv)
    if tstp > 0
        memcpy!(cfm.ret, cfv.ret)
        memcpy!(cfm.lmix, cfv.lmix, cfv.tstp)
        memcpy!(cfm.less, cfv.less)
    else
        memcpy!(cfm.mat, cfv.mat)
    end
end

"""
    memcpy!(cfv::𝒻{S}, cfm::ℱ{S}, tstp::I64)

Extract data from a `𝒻` object, then copy them to a `ℱ` object
(at given time step `tstp`).

See also: [`ℱ`](@ref), [`𝒻`](@ref).
"""
function memcpy!(cfv::𝒻{S}, cfm::ℱ{S}, tstp::I64) where {S}
    @assert tstp == gettstp(cfv)
    if tstp > 0
        memcpy!(cfv.ret, cfm.ret)
        memcpy!(cfv.lmix, cfm.lmix, cfv.tstp)
        memcpy!(cfv.less, cfm.less)
    else
        memcpy!(cfv.mat, cfm.mat)
    end
end

"""
    incr!(cfv1::𝒻{S}, cfv2::𝒻{S}, tstp::I64, alpha)

Adds a `𝒻` with given weight (`alpha`) to another `𝒻` (at given
time step `tstp`).
"""
function incr!(cfv1::𝒻{S}, cfv2::𝒻{S}, tstp::I64, alpha) where {S}
    @assert gettstp(cfv1) == gettstp(cfv2) == tstp
    α = convert(S, alpha)
    if tstp > 0
        incr!(cfv1.ret, cfv2.ret, α)
        incr!(cfv1.lmix, cfv2.lmix, α)
        incr!(cfv1.less, cfv2.less, α)
    else
        incr!(cfv1.mat, cfv2.mat, α)
    end
end

"""
    incr!(cfm::ℱ{S}, cfv::𝒻{S}, tstp::I64, alpha)

Adds a `𝒻` with given weight (`alpha`) to a `ℱ` (at given
time step `tstp`).
"""
function incr!(cfm::ℱ{S}, cfv::𝒻{S}, tstp::I64, alpha) where {S}
    @assert 0 ≤ tstp ≤ getntime(cfm)
    @assert tstp == gettstp(cfv)
    α = convert(S, alpha)
    if tstp > 0
        incr!(cfm.ret, cfv.ret, α)
        incr!(cfm.lmix, cfv.lmix, tstp, α)
        incr!(cfm.less, cfv.less, α)
    else
        incr!(cfm.mat, cfv.mat, α)
    end
end

"""
    incr!(cfv::𝒻{S}, cfm::ℱ{S}, tstp::I64, alpha)

Adds a `ℱ` with given weight (`alpha`) to a `𝒻` (at given
time step `tstp`).
"""
function incr!(cfv::𝒻{S}, cfm::ℱ{S}, tstp::I64, alpha) where {S}
    @assert 0 ≤ tstp ≤ getntime(cfm)
    @assert tstp == gettstp(cfv)
    α = convert(S, alpha)
    if tstp > 0
        incr!(cfv.ret, cfm.ret, α)
        incr!(cfv.lmix, cfm.lmix, tstp, α)
        incr!(cfv.less, cfm.less, α)
    else
        incr!(cfv.mat, cfm.mat, α)
    end
end

"""
    smul!(cfv::𝒻{S}, tstp::I64, alpha)

Multiply a `𝒻` with given weight (`alpha`) at given time
step `tstp`.
"""
function smul!(cfv::𝒻{S}, tstp::I64, alpha) where {S}
    @assert tstp == gettstp(cfv)
    α = convert(S, alpha)
    if tstp > 0
        smul!(cfv.ret, α)
        smul!(cfv.lmix, α)
        smul!(cfv.less, α)
    else
        smul!(cfv.mat, α)
    end
end

"""
    smul!(cff::Cf{S}, cfv::𝒻{S}, tstp::I64)

Left multiply a `𝒻` with given weight (`Cf`) at given time
step `tstp`.
"""
function smul!(cff::Cf{S}, cfv::𝒻{S}, tstp::I64) where {S}
    @assert tstp == gettstp(cfv)
    @assert tstp ≤ getsize(cff)
    if tstp > 0
        smul!(cff[tstp], cfv.ret)
        smul!(cff[tstp], cfv.lmix)
        smul!(cff, cfv.less)
    else
        smul!(cff[0], cfv.mat)
    end
end

"""
    smul!(cfv::𝒻{S}, cff::Cf{S}, tstp::I64)

Right multiply a `𝒻` with given weight (`Cf`) at given time
step `tstp`.
"""
function smul!(cfv::𝒻{S}, cff::Cf{S}, tstp::I64) where {S}
    @assert tstp == gettstp(cfv)
    @assert tstp ≤ getsize(cff)
    if tstp > 0
        smul!(cfv.ret, cff)
        smul!(cfv.lmix, cff[0])
        smul!(cfv.less, cff[tstp])
    else
        smul!(cfv.mat, cff[0])
    end
end

#=
### *𝒻* : *I/O*
=#

"""
    read!(fname::AbstractString, cfv::𝒻{S})

Read the contour Green's functions from given file.
"""
function read!(fname::AbstractString, cfv::𝒻{S}) where {S}
end

"""
    write(fname::AbstractString, cfv::𝒻{S})

Write the contour Green's functions to given file.
"""
function write(fname::AbstractString, cfv::𝒻{S}) where {S}
end

#=
### *𝒻* : *Traits*
=#
