#
# File: types.jl
#
# Provide the basic types and structs.
#

#=
### *Abstract Types*
=#

#=
*Remarks* :

We need a few abstract types to build the type systems.These abstract
types include:

* *CnAny*
* *CnAbsMat*
* *CnAbsVec*
* *CnAbsFun*

They should not be used in the user's applications directly.
=#

"""
    CnAny

Top abstract type for all objects defined on contour.
"""
abstract type CnAny end

"""
    CnAbsMat{T}

Abstract matrix type defined on contour.
"""
abstract type CnAbsMat{T} <: CnAny end

"""
    CnAbsVec{T}

Abstract vector type defined on contour.
"""
abstract type CnAbsVec{T} <: CnAny end

"""
    CnAbsFun{T}

Abstract contour function.
"""
abstract type CnAbsFun{T} <: CnAny end

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

See also: [`CnAny`](@ref).
"""
mutable struct Cn <: CnAny
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
### *CnFunF* : *Struct*
=#

"""
    CnFunF{T}

It is a square-matrix-valued or rectangle-matrix-valued function of time.

See also: [`CnFunM`](@ref), [`CnFunV`](@ref).
"""
mutable struct CnFunF{T} <: CnAbsFun{T}
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{T}
end

#=
### *CnFunF* : *Constructors*
=#

"""
    CnFunF(ntime::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnFunF(ntime::I64, ndim1::I64, ndim2::I64, v::T) where {T}
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
    CnFunF(ntime, ndim1, ndim2, data)
end

"""
    CnFunF(ntime::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnFunF(ntime::I64, ndim1::I64, ndim2::I64)
    CnFunF(ntime, ndim1, ndim2, CZERO)
end

"""
    CnFunF(ntime::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnFunF(ntime::I64, ndim1::I64)
    CnFunF(ntime, ndim1, ndim1, CZERO)
end

"""
    CnFunF(ntime::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnFunF(ntime::I64, x::Element{T}) where {T}
    # Sanity check
    @assert ntime ≥ 0

    ndim1, ndim2 = size(x)
    data = VecArray{T}(undef, ntime + 1)
    for i = 1:ntime + 1
        data[i] = copy(x)
    end

    # Call the default constructor
    CnFunF(ntime, ndim1, ndim2, data)
end

"""
    CnFunF(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnFunF(C::Cn, x::Element{T}) where {T}
    # Sanity check
    @assert getdims(C) == size(x)

    # Create VecArray{T}, whose size is indeed (ntime + 1,).
    data = VecArray{T}(undef, C.ntime + 1)
    for i = 1:C.ntime + 1
        data[i] = copy(x)
    end

    # Call the default constructor
    CnFunF(C.ntime, C.ndim1, C.ndim2, data)
end

"""
    CnFunF(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnFunF(C::Cn, v::T) where {T}
    CnFunF(C.ntime, C.ndim1, C.ndim2, v)
end

"""
    CnFunF(C::Cn)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnFunF(C::Cn)
    CnFunF(C.ntime, C.ndim1, C.ndim2, CZERO)
end

#=
### *CnFunF* : *Properties*
=#

"""
    getdims(cff::CnFunF{T})

Return the dimensional parameters of contour function.

See also: [`CnFunF`](@ref).
"""
function getdims(cff::CnFunF{T}) where {T}
    return (cff.ndim1, cff.ndim2)
end

"""
    getsize(cff::CnFunF{T})

Return the nominal size of contour function, i.e `ntime`. Actually, the
real size of contour function should be `ntime + 1`.

See also: [`CnFunF`](@ref).
"""
function getsize(cff::CnFunF{T}) where {T}
    return cff.ntime
end

"""
    equaldims(cff::CnFunF{T})

Return whether the dimensional parameters are equal.

See also: [`CnFunF`](@ref).
"""
function equaldims(cff::CnFunF{T}) where {T}
    return cff.ndim1 == cff.ndim2
end

"""
    iscompatible(cff1::CnFunF{T}, cff2::CnFunF{T})

Judge whether two `CnFunF` objects are compatible.
"""
function iscompatible(cff1::CnFunF{T}, cff2::CnFunF{T}) where {T}
    getsize(cff1) == getsize(cff2) &&
    getdims(cff1) == getdims(cff2)
end

"""
    iscompatible(C::Cn, cff::CnFunF{T})

Judge whether `C` (which is a `Cn` object) is compatible with `cff`
(which is a `CnFunF{T}` object).
"""
function iscompatible(C::Cn, cff::CnFunF{T}) where {T}
    C.ntime == getsize(cff) &&
    getdims(C) == getdims(cff)
end

"""
    iscompatible(cff::CnFunF{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `cff`
(which is a `CnFunF{T}` object).
"""
iscompatible(cff::CnFunF{T}, C::Cn) where {T} = iscompatible(C, cff)

#=
### *CnFunF* : *Indexing*
=#

"""
    Base.getindex(cff::CnFunF{T}, i::I64)

Visit the element stored in `CnFunF` object. If `i = 0`, it returns
the element at Matsubara axis. On the other hand, if `it > 0`, it will
return elements at real time axis.
"""
function Base.getindex(cff::CnFunF{T}, i::I64) where {T}
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
    Base.setindex!(cff::CnFunF{T}, x::Element{T}, i::I64)

Setup the element in `CnFunF` object. If `i = 0`, it will setup the
element at Matsubara axis to `x`. On the other hand, if `it > 0`, it
will setup elements at real time axis.
"""
function Base.setindex!(cff::CnFunF{T}, x::Element{T}, i::I64) where {T}
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
    Base.setindex!(cff::CnFunF{T}, v::T, i::I64)

Setup the element in `CnFunF` object. If `i = 0`, it will setup the
element at Matsubara axis to `v`. On the other hand, if `it > 0`, it
will setup elements at real time axis. Here, `v` should be a scalar
number.
"""
function Base.setindex!(cff::CnFunF{T}, v::T, i::I64) where {T}
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
### *CnFunF* : *Operations*
=#

"""
    memset!(cff::CnFunF{T}, x)

Reset all the matrix elements of `cff` to `x`. `x` should be a
scalar number.
"""
function memset!(cff::CnFunF{T}, x) where {T}
    cx = convert(T, x)
    for i = 1:cff.ntime + 1
        fill!(cff.data[i], cx)
    end
end

"""
    zeros!(cff::CnFunF{T})

Reset all the matrix elements of `cff` to `ZERO`.
"""
zeros!(cff::CnFunF{T}) where {T} = memset!(cff, zero(T))

"""
    memcpy!(src::CnFunF{T}, dst::CnFunF{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnFunF{T}, dst::CnFunF{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    incr!(cff1::CnFunF{T}, cff2::CnFunF{T}, alpha::T)

Add a `CnFunF` with given weight (`alpha`) to another `CnFunF`. Finally,
`cff1` will be changed.
"""
function incr!(cff1::CnFunF{T}, cff2::CnFunF{T}, alpha::T) where {T}
    @assert iscompatible(cff1, cff2)
    for i = 1:cff1.ntime + 1
        @. cff1.data[i] = cff1.data[i] + cff2.data[i] * alpha
    end
end

"""
    smul!(cff::CnFunF{T}, alpha::T)

Multiply a `CnFunF` with given weight (`alpha`).
"""
function smul!(cff::CnFunF{T}, alpha::T) where {T}
    for i = 1:cff.ntime + 1
        @. cff.data[i] = cff.data[i] * alpha
    end
end

"""
    smul!(x::Element{T}, cff::CnFunF{T})

Left multiply a `CnFunF` with given weight (`x`).
"""
function smul!(x::Element{T}, cff::CnFunF{T}) where {T}
    for i = 1:cff.ntime + 1
        cff.data[i] = x * cff.data[i]
    end
end

"""
    smul!(cff::CnFunF{T}, x::Element{T})

Right multiply a `CnFunF` with given weight (`x`).
"""
function smul!(cff::CnFunF{T}, x::Element{T}) where {T}
    for i = 1:cff.ntime + 1
        cff.data[i] = cff.data[i] * x
    end
end

#=
### *CnFunF* : *Traits*
=#

"""
    Base.:+(cff1::CnFunF{T}, cff2::CnFunF{T})

Operation `+` for two `CnFunF` objects.
"""
function Base.:+(cff1::CnFunF{T}, cff2::CnFunF{T}) where {T}
    # Sanity check
    @assert getsize(cff1) == getsize(cff2)
    @assert getdims(cff1) == getdims(cff2)

    CnFunF(cff1.ntime, cff1.ndim1, cff1.ndim2, cff1.data + cff2.data)
end

"""
    Base.:-(cff1::CnFunF{T}, cff2::CnFunF{T})

Operation `-` for two `CnFunF` objects.
"""
function Base.:-(cff1::CnFunF{T}, cff2::CnFunF{T}) where {T}
    # Sanity check
    @assert getsize(cff1) == getsize(cff2)
    @assert getdims(cff1) == getdims(cff2)

    CnFunF(cff1.ntime, cff1.ndim1, cff1.ndim2, cff1.data - cff2.data)
end

"""
    Base.:*(cff::CnFunF{T}, x)

Operation `*` for a `CnFunF` object and a scalar value.
"""
function Base.:*(cff::CnFunF{T}, x) where {T}
    cx = convert(T, x)
    CnFunF(cff.ntime, cff.ndim1, cff.ndim2, cff.data * cx)
end

"""
    Base.:*(x, cff::CnFunF{T})

Operation `*` for a scalar value and a `CnFunF` object.
"""
Base.:*(x, cff::CnFunF{T}) where {T} = Base.:*(cff, x)

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
### *CnMatM* : *Struct*
=#

"""
    CnMatM{T}

Matsubara component (``G^M``) of contour Green's function. We usually
call this component `mat`. Here we just assume ``\tau ≥ 0``. While for
``\tau < 0``, please turn to the `CnMatmM{T}` struct.

See also: [`CnRetM`](@ref), [`CnLmixM`](@ref), [`CnLessM`](@ref).
"""
mutable struct CnMatM{T} <: CnAbsMat{T}
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *CnMatM* : *Constructors*
=#

"""
    CnMatM(ntau::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnMatM(ntau::I64, ndim1::I64, ndim2::I64, v::T) where {T}
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
    CnMatM(ntau, ndim1, ndim2, data)
end

"""
    CnMatM(ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnMatM(ntau::I64, ndim1::I64, ndim2::I64)
    CnMatM(ntau, ndim1, ndim2, CZERO)
end

"""
    CnMatM(ntau::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnMatM(ntau::I64, ndim1::I64)
    CnMatM(ntau, ndim1, ndim1, CZERO)
end

"""
    CnMatM(ntau::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnMatM(ntau::I64, x::Element{T}) where {T}
    # Sanity check
    @assert ntau ≥ 2

    ndim1, ndim2 = size(x)
    data = MatArray{T}(undef, ntau, 1)
    for i=1:ntau
        data[i,1] = copy(x)
    end

    # Call the default constructor
    CnMatM(ntau, ndim1, ndim2, data)
end

"""
    CnMatM(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnMatM(C::Cn, x::Element{T}) where {T}
    # Sanity check
    @assert getdims(C) == size(x)

    # Create MatArray{T}, whose size is indeed (ntau, 1).
    data = MatArray{T}(undef, C.ntau, 1)
    for i=1:C.ntau
        data[i,1] = copy(x)
    end

    # Call the default constructor
    CnMatM(C.ntau, C.ndim1, C.ndim2, data)
end

"""
    CnMatM(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnMatM(C::Cn, v::T) where {T}
    CnMatM(C.ntau, C.ndim1, C.ndim2, v)
end

"""
    CnMatM(C::Cn)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnMatM(C::Cn)
    CnMatM(C.ntau, C.ndim1, C.ndim2, CZERO)
end

#=
### *CnMatM* : *Properties*
=#

"""
    getdims(mat::CnMatM{T})

Return the dimensional parameters of contour function.

See also: [`CnMatM`](@ref).
"""
function getdims(mat::CnMatM{T}) where {T}
    return (mat.ndim1, mat.ndim2)
end

"""
    getsize(mat::CnMatM{T})

Return the size of contour function. Here, it should be `ntau`.

See also: [`CnMatM`](@ref).
"""
function getsize(mat::CnMatM{T}) where {T}
    return mat.ntau
end

"""
    equaldims(mat::CnMatM{T})

Return whether the dimensional parameters are equal.

See also: [`CnMatM`](@ref).
"""
function equaldims(mat::CnMatM{T}) where {T}
    return mat.ndim1 == mat.ndim2
end

"""
    iscompatible(mat1::CnMatM{T}, mat2::CnMatM{T})

Judge whether two `CnMatM` objects are compatible.
"""
function iscompatible(mat1::CnMatM{T}, mat2::CnMatM{T}) where {T}
    getsize(mat1) == getsize(mat2) &&
    getdims(mat1) == getdims(mat2)
end

"""
    iscompatible(C::Cn, mat::CnMatM{T})

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `CnMatM{T}` object).
"""
function iscompatible(C::Cn, mat::CnMatM{T}) where {T}
    C.ntau == getsize(mat) &&
    getdims(C) == getdims(mat)
end

"""
    iscompatible(mat::CnMatM{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `CnMatM{T}` object).
"""
iscompatible(mat::CnMatM{T}, C::Cn) where {T} = iscompatible(C, mat)

"""
    distance(mat1::CnMatM{T}, mat2::CnMatM{T})

Calculate distance between two `CnMatM` objects.
"""
function distance(mat1::CnMatM{T}, mat2::CnMatM{T}) where {T}
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
### *CnMatM* : *Indexing*
=#

"""
    Base.getindex(mat::CnMatM{T}, ind::I64)

Visit the element stored in `CnMatM` object.
"""
function Base.getindex(mat::CnMatM{T}, ind::I64) where {T}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # Return G^{M}(τᵢ ≥ 0)
    mat.data[ind,1]
end

"""
    Base.setindex!(mat::CnMatM{T}, x::Element{T}, ind::I64)

Setup the element in `CnMatM` object.
"""
function Base.setindex!(mat::CnMatM{T}, x::Element{T}, ind::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(mat)
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) = x
    mat.data[ind,1] = copy(x)
end

"""
    Base.setindex!(mat::CnMatM{T}, v::T, ind::I64)

Setup the element in `CnMatM` object.
"""
function Base.setindex!(mat::CnMatM{T}, v::T, ind::I64) where {T}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) .= v
    fill!(mat.data[ind,1], v)
end

#=
### *CnMatM* : *Operations*
=#

"""
    memset!(mat::CnMatM{T}, x)

Reset all the matrix elements of `mat` to `x`. `x` should be a
scalar number.
"""
function memset!(mat::CnMatM{T}, x) where {T}
    cx = convert(T, x)
    for i = 1:mat.ntau
        fill!(mat.data[i,1], cx)
    end
end

"""
    zeros!(mat::CnMatM{T})

Reset all the matrix elements of `mat` to `ZERO`.
"""
zeros!(mat::CnMatM{T}) where {T} = memset!(mat, zero(T))

"""
    memcpy!(src::CnMatM{T}, dst::CnMatM{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnMatM{T}, dst::CnMatM{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    incr!(mat1::CnMatM{T}, mat2::CnMatM{T}, alpha::T)

Add a `CnMatM` with given weight (`alpha`) to another `CnMatM`.

```math
G^M_1 ⟶ G^M_1 + α * G^M_2.
```
"""
function incr!(mat1::CnMatM{T}, mat2::CnMatM{T}, alpha::T) where {T}
    @assert iscompatible(mat1, mat2)
    for i = 1:mat2.ntau
        @. mat1.data[i,1] = mat1.data[i,1] + mat2.data[i,1] * alpha
    end
end

"""
    smul!(mat::CnMatM{T}, alpha::T)

Multiply a `CnMatM` with given weight (`alpha`).

```math
G^M ⟶ α * G^M.
```
"""
function smul!(mat::CnMatM{T}, alpha::T) where {T}
    for i = 1:mat.ntau
        @. mat.data[i,1] = mat.data[i,1] * alpha
    end
end

"""
    smul!(x::Element{T}, mat::CnMatM{T})

Left multiply a `CnMatM` with given weight (`x`), which is actually a
matrix.
"""
function smul!(x::Element{T}, mat::CnMatM{T}) where {T}
    for i = 1:mat.ntau
        mat.data[i,1] = x * mat.data[i,1]
    end
end

"""
    smul!(mat::CnMatM{T}, x::Element{T})

Right multiply a `CnMatM` with given weight (`x`), which is actually a
matrix.
"""
function smul!(mat::CnMatM{T}, x::Element{T}) where {T}
    for i = 1:mat.ntau
        mat.data[i,1] = mat.data[i,1] * x
    end
end

#=
### *CnMatM* : *Traits*
=#

"""
    Base.:+(mat1::CnMatM{T}, mat2::CnMatM{T})

Operation `+` for two `CnMatM` objects.
"""
function Base.:+(mat1::CnMatM{T}, mat2::CnMatM{T}) where {T}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    CnMatM(mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data + mat2.data)
end

"""
    Base.:-(mat1::CnMatM{T}, mat2::CnMatM{T})

Operation `-` for two `CnMatM` objects.
"""
function Base.:-(mat1::CnMatM{T}, mat2::CnMatM{T}) where {T}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    CnMatM(mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data - mat2.data)
end

"""
    Base.:*(mat::CnMatM{T}, x)

Operation `*` for a `CnMatM` object and a scalar value.
"""
function Base.:*(mat::CnMatM{T}, x) where {T}
    cx = convert(T, x)
    CnMatM(mat.ntau, mat.ndim1, mat.ndim2, mat.data * cx)
end

"""
    Base.:*(x, mat::CnMatM{T})

Operation `*` for a scalar value and a `CnMatM` object.
"""
Base.:*(x, mat::CnMatM{T}) where {T} = Base.:*(mat, x)

#=
### *CnMatmM* : *Struct*
=#

"""
    CnMatmM{T}

Matsubara component (``G^M``) of contour Green's function. It is designed
for ``\tau < 0`` case. It is not an independent component. It can be
inferred or deduced from the `CnMatM{T}` struct. We usually call this
component `matm`.

See also: [`CnRetM`](@ref), [`CnLmixM`](@ref), [`CnLessM`](@ref).
"""
mutable struct CnMatmM{T} <: CnAbsMat{T}
    sign  :: I64 # Used to distinguish fermions and bosons
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataM :: Ref{CnMatM{T}}
end

#=
### *CnMatmM* : *Constructors*
=#

"""
    CnMatmM(sign::I64, mat::CnMatM{T})

Constructor. Note that the `matm` component is not independent. We use
the `mat` component to initialize it.
"""
function CnMatmM(sign::I64, mat::CnMatM{T}) where {T}
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
    CnMatmM(sign, ntau, ndim1, ndim2, dataM)
end

#=
### *CnMatmM* : *Indexing*
=#

"""
    Base.getindex(matm::CnMatmM{T}, ind::I64)

Visit the element stored in `CnMatmM` object.
"""
function Base.getindex(matm::CnMatmM{T}, ind::I64) where {T}
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
### *CnRetM* : *Struct*
=#

"""
    CnRetM{T}

Retarded component (``G^R``) of contour Green's function.

See also: [`CnMatM`](@ref), [`CnLmixM`](@ref), [`CnLessM`](@ref).
"""
mutable struct CnRetM{T} <: CnAbsMat{T}
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *CnRetM* : *Constructors*
=#

"""
    CnRetM(ntime::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnRetM(ntime::I64, ndim1::I64, ndim2::I64, v::T) where {T}
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
    CnRetM(ntime, ndim1, ndim2, data)
end

"""
    CnRetM(ntime::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnRetM(ntime::I64, ndim1::I64, ndim2::I64)
    CnRetM(ntime, ndim1, ndim2, CZERO)
end

"""
    CnRetM(ntime::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnRetM(ntime::I64, ndim1::I64)
    CnRetM(ntime, ndim1, ndim1, CZERO)
end

"""
    CnRetM(ntime::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnRetM(ntime::I64, x::Element{T}) where {T}
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
    CnRetM(ntime, ndim1, ndim2, data)
end

"""
    CnRetM(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnRetM(C::Cn, x::Element{T}) where {T}
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
    CnRetM(C.ntime, C.ndim1, C.ndim2, data)
end

"""
    CnRetM(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnRetM(C::Cn, v::T) where {T}
    CnRetM(C.ntime, C.ndim1, C.ndim2, v)
end

"""
    CnRetM(C::Cn)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnRetM(C::Cn)
    CnRetM(C.ntime, C.ndim1, C.ndim2, CZERO)
end

#=
### *CnRetM* : *Properties*
=#

"""
    getdims(ret::CnRetM{T})

Return the dimensional parameters of contour function.

See also: [`CnRetM`](@ref).
"""
function getdims(ret::CnRetM{T}) where {T}
    return (ret.ndim1, ret.ndim2)
end

"""
    getsize(ret::CnRetM{T})

Return the size of contour function.

See also: [`CnRetM`](@ref).
"""
function getsize(ret::CnRetM{T}) where {T}
    return ret.ntime
end

"""
    equaldims(ret::CnRetM{T})

Return whether the dimensional parameters are equal.

See also: [`CnRetM`](@ref).
"""
function equaldims(ret::CnRetM{T}) where {T}
    return ret.ndim1 == ret.ndim2
end

"""
    iscompatible(ret1::CnRetM{T}, ret2::CnRetM{T})

Judge whether two `CnRetM` objects are compatible.
"""
function iscompatible(ret1::CnRetM{T}, ret2::CnRetM{T}) where {T}
    getsize(ret1) == getsize(ret2) &&
    getdims(ret1) == getdims(ret2)
end

"""
    iscompatible(C::Cn, ret::CnRetM{T})

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `CnRetM{T}` object).
"""
function iscompatible(C::Cn, ret::CnRetM{T}) where {T}
    C.ntime == getsize(ret) &&
    getdims(C) == getdims(ret)
end

"""
    iscompatible(ret::CnRetM{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `CnRetM{T}` object).
"""
iscompatible(ret::CnRetM{T}, C::Cn) where {T} = iscompatible(C, ret)

"""
    distance(ret1::CnRetM{T}, ret2::CnRetM{T}, tstp::I64)

Calculate distance between two `CnRetM` objects at given time step `tstp`.
"""
function distance(ret1::CnRetM{T}, ret2::CnRetM{T}, tstp::I64) where {T}
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
### *CnRetM* : *Indexing*
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
    Base.getindex(ret::CnRetM{T}, i::I64, j::I64)

Visit the element stored in `CnRetM` object. Here `i` and `j` are indices
for real times.
"""
function Base.getindex(ret::CnRetM{T}, i::I64, j::I64) where {T}
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
    Base.setindex!(ret::CnRetM{T}, x::Element{T}, i::I64, j::I64)

Setup the element in `CnRetM` object.
"""
function Base.setindex!(ret::CnRetM{T}, x::Element{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(ret)
    @assert 1 ≤ i ≤ ret.ntime
    @assert 1 ≤ j ≤ ret.ntime

    # G^{R}(tᵢ, tⱼ) = x
    ret.data[i,j] = copy(x)
end

"""
    Base.setindex!(ret::CnRetM{T}, v::T, i::I64, j::I64)

Setup the element in `CnRetM` object.
"""
function Base.setindex!(ret::CnRetM{T}, v::T, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ ret.ntime
    @assert 1 ≤ j ≤ ret.ntime

    # G^{R}(tᵢ, tⱼ) .= v
    fill!(ret.data[i,j], v)
end

#=
### *CnRetM* : *Operations*
=#

"""
    memset!(ret::CnRetM{T}, x)

Reset all the matrix elements of `ret` to `x`. `x` should be a
scalar number.
"""
function memset!(ret::CnRetM{T}, x) where {T}
    cx = convert(T, x)
    for i=1:ret.ntime
        for j=1:ret.ntime
            fill!(ret.data[j,i], cx)
        end
    end
end

"""
    memset!(ret::CnRetM{T}, tstp::I64, x)

Reset the matrix elements of `ret` at given time step `tstp` to `x`. `x`
should be a scalar number.
"""
function memset!(ret::CnRetM{T}, tstp::I64, x) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    cx = convert(T, x)
    for i=1:tstp
        fill!(ret.data[tstp,i], cx)
    end
end

"""
    zeros!(ret::CnRetM{T})

Reset all the matrix elements of `ret` to `ZERO`.
"""
zeros!(ret::CnRetM{T}) where {T} = memset!(ret, zero(T))

"""
    zeros!(ret::CnRetM{T}, tstp::I64)

Reset the matrix elements of `ret` at given time step `tstp` to `ZERO`.
"""
zeros!(ret::CnRetM{T}, tstp::I64) where {T} = memset!(ret, tstp, zero(T))

"""
    memcpy!(src::CnRetM{T}, dst::CnRetM{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnRetM{T}, dst::CnRetM{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::CnRetM{T}, dst::CnRetM{T}, tstp::I64)

Copy some matrix elements from `src` to `dst`. Only the matrix elements
at given time step `tstp` are copied.
"""
function memcpy!(src::CnRetM{T}, dst::CnRetM{T}, tstp::I64) where {T}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    for i=1:tstp
        dst.data[tstp,i] = copy(src.data[tstp,i])
    end
end

"""
    incr!(ret1::CnRetM{T}, ret2::CnRetM{T}, tstp::I64, alpha::T)

Add a `CnRetM` with given weight (`alpha`) at given time step `tstp` to
another `CnRetM`.
"""
function incr!(ret1::CnRetM{T}, ret2::CnRetM{T}, tstp::I64, alpha::T) where {T}
    @assert iscompatible(ret1, ret2)
    @assert 1 ≤ tstp ≤ ret2.ntime
    for i = 1:tstp
        @. ret1.data[tstp,i] = ret1.data[tstp,i] + ret2.data[tstp,i] * alpha
    end
end

"""
    smul!(ret::CnRetM{T}, tstp::I64, alpha::T)

Multiply a `CnRetM` with given weight (`alpha`) at given time step `tstp`.
"""
function smul!(ret::CnRetM{T}, tstp::I64, alpha::T) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    for i = 1:tstp
        @. ret.data[tstp,i] = ret.data[tstp,i] * alpha
    end
end

"""
    smul!(x::Element{T}, ret::CnRetM{T}, tstp::I64)

Left multiply a `CnRetM` with given weight (`x`) at given time step `tstp`.
"""
function smul!(x::Element{T}, ret::CnRetM{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    for i = 1:tstp
        ret.data[tstp,i] = x * ret.data[tstp,i]
    end
end

"""
    smul!(ret::CnRetM{T}, x::CnFunF{T}, tstp::I64)

Right multiply a `CnRetM` with given weight (`x`) at given time step `tstp`.
"""
function smul!(ret::CnRetM{T}, x::CnFunF{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ ret.ntime
    for i = 1:tstp
        ret.data[tstp,i] = ret.data[tstp,i] * x[i]
    end
end

#=
### *CnRetM* : *Traits*
=#

"""
    Base.:+(ret1::CnRetM{T}, ret2::CnRetM{T})

Operation `+` for two `CnRetM` objects.
"""
function Base.:+(ret1::CnRetM{T}, ret2::CnRetM{T}) where {T}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    CnRetM(ret1.ntime, ret1.ndim1, ret1.ndim2, ret1.data + ret2.data)
end

"""
    Base.:-(ret1::CnRetM{T}, ret2::CnRetM{T})

Operation `-` for two `CnRetM` objects.
"""
function Base.:-(ret1::CnRetM{T}, ret2::CnRetM{T}) where {T}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    CnRetM(ret1.ntime, ret1.ndim1, ret1.ndim2, ret1.data - ret2.data)
end

"""
    Base.:*(ret::CnRetM{T}, x)

Operation `*` for a `CnRetM` object and a scalar value.
"""
function Base.:*(ret::CnRetM{T}, x) where {T}
    cx = convert(T, x)
    CnRetM(ret.ntime, ret.ndim1, ret.ndim2, ret.data * cx)
end

"""
    Base.:*(x, ret::CnRetM{T})

Operation `*` for a scalar value and a `CnRetM` object.
"""
Base.:*(x, ret::CnRetM{T}) where {T} = Base.:*(ret, x)

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
### *CnAdvM* : *Struct*
=#

"""
    CnAdvM{T}

Advanced component (``G^{A}``) of contour Green's function.

Note: currently we do not need this component explicitly. However, for
the sake of completeness, we still define an empty struct for it.

See also: [`CnMatM`](@ref), [`CnLmixM`](@ref), [`CnLessM`](@ref).
"""
mutable struct CnAdvM{T} <: CnAbsMat{T} end

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
### *CnLmixM* : *Struct*
=#

"""
    CnLmixM{T}

Left-mixing component (``G^{⌉}``) of contour Green's function.

See also: [`CnMatM`](@ref), [`CnRetM`](@ref), [`CnLessM`](@ref).
"""
mutable struct CnLmixM{T} <: CnAbsMat{T}
    ntime :: I64
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *CnLmixM* : *Constructors*
=#

"""
    CnLmixM(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnLmixM(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64, v::T) where {T}
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
    CnLmixM(ntime, ntau, ndim1, ndim2, data)
end

"""
    CnLmixM(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLmixM(ntime::I64, ntau::I64, ndim1::I64, ndim2::I64)
    CnLmixM(ntime, ntau, ndim1, ndim2, CZERO)
end

"""
    CnLmixM(ntime::I64, ntau::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLmixM(ntime::I64, ntau::I64, ndim1::I64)
    CnLmixM(ntime, ntau, ndim1, ndim1, CZERO)
end

"""
    CnLmixM(ntime::I64, ntau::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnLmixM(ntime::I64, ntau::I64, x::Element{T}) where {T}
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
    CnLmixM(ntime, ntau, ndim1, ndim2, data)
end

"""
    CnLmixM(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnLmixM(C::Cn, x::Element{T}) where {T}
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
    CnLmixM(C.ntime, C.ntau, C.ndim1, C.ndim2, data)
end

"""
    CnLmixM(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnLmixM(C::Cn, v::T) where {T}
    CnLmixM(C.ntime, C.ntau, C.ndim1, C.ndim2, v)
end

"""
    CnLmixM(C::Cn)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLmixM(C::Cn)
    CnLmixM(C.ntime, C.ntau, C.ndim1, C.ndim2, CZERO)
end

#=
### *CnLmixM* : *Properties*
=#

"""
    getdims(lmix::CnLmixM{T})

Return the dimensional parameters of contour function.

See also: [`CnLmixM`](@ref).
"""
function getdims(lmix::CnLmixM{T}) where {T}
    return (lmix.ndim1, lmix.ndim2)
end

"""
    getsize(lmix::CnLmixM{T})

Return the size of contour function.

See also: [`CnLmixM`](@ref).
"""
function getsize(lmix::CnLmixM{T}) where {T}
    return (lmix.ntime, lmix.ntau)
end

"""
    equaldims(lmix::CnLmixM{T})

Return whether the dimensional parameters are equal.

See also: [`CnLmixM`](@ref).
"""
function equaldims(lmix::CnLmixM{T}) where {T}
    return lmix.ndim1 == lmix.ndim2
end

"""
    iscompatible(lmix1::CnLmixM{T}, lmix2::CnLmixM{T})

Judge whether two `CnLmixM` objects are compatible.
"""
function iscompatible(lmix1::CnLmixM{T}, lmix2::CnLmixM{T}) where {T}
    getsize(lmix1) == getsize(lmix2) &&
    getdims(lmix1) == getdims(lmix2)
end

"""
    iscompatible(C::Cn, lmix::CnLmixM{T})

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `CnLmixM{T}` object).
"""
function iscompatible(C::Cn, lmix::CnLmixM{T}) where {T}
    C.ntime, C.ntau == getsize(lmix) &&
    getdims(C) == getdims(lmix)
end

"""
    iscompatible(lmix::CnLmixM{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `CnLmixM{T}` object).
"""
iscompatible(lmix::CnLmixM{T}, C::Cn) where {T} = iscompatible(C, lmix)

"""
    distance(lmix1::CnLmixM{T}, lmix2::CnLmixM{T}, tstp::I64)

Calculate distance between two `CnLmixM` objects at given time step `tstp`.
"""
function distance(lmix1::CnLmixM{T}, lmix2::CnLmixM{T}, tstp::I64) where {T}
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
### *CnLmixM* : *Indexing*
=#

"""
    Base.getindex(lmix::CnLmixM{T}, i::I64, j::I64)

Visit the element stored in `CnLmixM` object.
"""
function Base.getindex(lmix::CnLmixM{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ lmix.ntime
    @assert 1 ≤ j ≤ lmix.ntau

    # Return G^{⌉}(tᵢ, τⱼ)
    lmix.data[i,j]
end

"""
    Base.setindex!(lmix::CnLmixM{T}, x::Element{T}, i::I64, j::I64)

Setup the element in `CnLmixM` object.
"""
function Base.setindex!(lmix::CnLmixM{T}, x::Element{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(lmix)
    @assert 1 ≤ i ≤ lmix.ntime
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ, τⱼ) = x
    lmix.data[i,j] = copy(x)
end

"""
    Base.setindex!(lmix::CnLmixM{T}, v::T, i::I64, j::I64)

Setup the element in `CnLmixM` object.
"""
function Base.setindex!(lmix::CnLmixM{T}, v::T, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ lmix.ntime
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ, τⱼ) .= v
    fill!(lmix.data[i,j], v)
end

#=
### *CnLmixM* : *Operations*
=#

"""
    memset!(lmix::CnLmixM{T}, x)

Reset all the matrix elements of `lmix` to `x`. `x` should be a
scalar number.
"""
function memset!(lmix::CnLmixM{T}, x) where {T}
    cx = convert(T, x)
    for i=1:lmix.ntau
        for j=1:lmix.ntime
            fill!(lmix.data[j,i], cx)
        end
    end
end

"""
    memset!(lmix::CnLmixM{T}, tstp::I64, x)

Reset the matrix elements of `lmix` at given time step `tstp` to `x`. `x`
should be a scalar number.
"""
function memset!(lmix::CnLmixM{T}, tstp::I64, x) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    cx = convert(T, x)
    for i=1:lmix.ntau
        fill!(lmix.data[tstp,i], cx)
    end
end

"""
    zeros!(lmix::CnLmixM{T})

Reset all the matrix elements of `lmix` to `ZERO`.
"""
zeros!(lmix::CnLmixM{T}) where {T} = memset!(lmix, zero(T))

"""
    zeros!(lmix::CnLmixM{T}, tstp::I64)

Reset the matrix elements of `lmix` at given time step `tstp` to `ZERO`.
"""
zeros!(lmix::CnLmixM{T}, tstp::I64) where {T} = memset!(lmix, tstp, zero(T))

"""
    memcpy!(src::CnLmixM{T}, dst::CnLmixM{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnLmixM{T}, dst::CnLmixM{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::CnLmixM{T}, dst::CnLmixM{T}, tstp::I64)

Copy some matrix elements from `src` to `dst`. Only the matrix elements
at given time step `tstp` are copied.
"""
function memcpy!(src::CnLmixM{T}, dst::CnLmixM{T}, tstp::I64) where {T}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    for i=1:src.ntau
        dst.data[tstp,i] = copy(src.data[tstp,i])
    end
end

"""
    incr!(lmix1::CnLmixM{T}, lmix2::CnLmixM{T}, tstp::I64, alpha::T)

Add a `CnLmixM` with given weight (`alpha`) at given time step `tstp` to
another `CnLmixM`.
"""
function incr!(lmix1::CnLmixM{T}, lmix2::CnLmixM{T}, tstp::I64, alpha::T) where {T}
    @assert iscompatible(lmix1, lmix2)
    @assert 1 ≤ tstp ≤ lmix2.ntime
    for i = 1:lmix2.ntau
        @. lmix1.data[tstp,i] = lmix1.data[tstp,i] + lmix2.data[tstp,i] * alpha
    end
end

"""
    smul!(lmix::CnLmixM{T}, tstp::I64, alpha::T)

Multiply a `CnLmixM` with given weight (`alpha`) at given time
step `tstp`.
"""
function smul!(lmix::CnLmixM{T}, tstp::I64, alpha::T) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    for i = 1:lmix.ntau
        @. lmix.data[tstp,i] = lmix.data[tstp,i] * alpha
    end
end

"""
    smul!(x::Element{T}, lmix::CnLmixM{T}, tstp::I64)

Left multiply a `CnLmixM` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(x::Element{T}, lmix::CnLmixM{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    for i = 1:lmix.ntau
        lmix.data[tstp,i] = x * lmix.data[tstp,i]
    end
end

"""
    smul!(lmix::CnLmixM{T}, x::Element{T}, tstp::I64)

Right multiply a `CnLmixM` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(lmix::CnLmixM{T}, x::Element{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ lmix.ntime
    for i = 1:lmix.ntau
        lmix.data[tstp,i] = lmix.data[tstp,i] * x
    end
end

#=
### *CnLmixM* : *Traits*
=#

"""
    Base.:+(lmix1::CnLmixM{T}, lmix2::CnLmixM{T})

Operation `+` for two `CnLmixM` objects.
"""
function Base.:+(lmix1::CnLmixM{T}, lmix2::CnLmixM{T}) where {T}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    CnLmixM(lmix1.ntime, lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data + lmix2.data)
end

"""
    Base.:-(lmix1::CnLmixM{T}, lmix2::CnLmixM{T})

Operation `-` for two `CnLmixM` objects.
"""
function Base.:-(lmix1::CnLmixM{T}, lmix2::CnLmixM{T}) where {T}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    CnLmixM(lmix1.ntime, lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data - lmix2.data)
end

"""
    Base.:*(lmix::CnLmixM{T}, x)

Operation `*` for a `CnLmixM` object and a scalar value.
"""
function Base.:*(lmix::CnLmixM{T}, x) where {T}
    cx = convert(T, x)
    CnLmixM(lmix.ntime, lmix.ntau, lmix.ndim1, lmix.ndim2, lmix.data * cx)
end

"""
    Base.:*(x, lmix::CnLmixM{T})

Operation `*` for a scalar value and a `CnLmixM` object.
"""
Base.:*(x, lmix::CnLmixM{T}) where {T} = Base.:*(lmix, x)

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
### *CnRmixM* : *Struct*
=#

"""
    CnRmixM{T}

Right-mixing component (``G^{⌈}``) of contour Green's function.

See also: [`CnMatM`](@ref), [`CnRetM`](@ref), [`CnLessM`](@ref).
"""
mutable struct CnRmixM{T} <: CnAbsMat{T}
    sign  :: I64 # Used to distinguish fermions and bosons
    ntime :: I64
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataL :: Ref{CnLmixM{T}}
end

#=
### *CnRmixM* : *Constructors*
=#

"""
    CnRmixM(sign::I64, lmix::CnLmixM{T})

Constructor. Note that the `rmix` component is not independent. We use
the `lmix` component to initialize it.
"""
function CnRmixM(sign::I64, lmix::CnLmixM{T}) where {T}
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
    CnRmixM(sign, ntime, ntau, ndim1, ndim2, dataL)
end

#=
### *CnRmixM* : *Indexing*
=#

"""
    Base.getindex(rmix::CnRmixM{T}, i::I64, j::I64)

Visit the element stored in `CnRmixM` object.
"""
function Base.getindex(rmix::CnRmixM{T}, i::I64, j::I64) where {T}
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
### *CnLessM* : *Struct*
=#

"""
    CnLessM{T}

Lesser component (``G^{<}``) of contour Green's function.

See also: [`CnMatM`](@ref), [`CnRetM`](@ref), [`CnLmixM`](@ref).
"""
mutable struct CnLessM{T} <: CnAbsMat{T}
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: MatArray{T}
end

#=
### *CnLessM* : *Constructors*
=#

"""
    CnLessM(ntime::I64, ndim1::I64, ndim2::I64, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnLessM(ntime::I64, ndim1::I64, ndim2::I64, v::T) where {T}
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
    CnLessM(ntime, ndim1, ndim2, data)
end

"""
    CnLessM(ntime::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLessM(ntime::I64, ndim1::I64, ndim2::I64)
    CnLessM(ntime, ndim1, ndim2, CZERO)
end

"""
    CnLessM(ntime::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLessM(ntime::I64, ndim1::I64)
    CnLessM(ntime, ndim1, ndim1, CZERO)
end

"""
    CnLessM(ntime::I64, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnLessM(ntime::I64, x::Element{T}) where {T}
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
    CnLessM(ntime, ndim1, ndim2, data)
end

"""
    CnLessM(C::Cn, x::Element{T})

Constructor. The matrix is initialized by `x`.
"""
function CnLessM(C::Cn, x::Element{T}) where {T}
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
    CnLessM(C.ntime, C.ndim1, C.ndim2, data)
end

"""
    CnLessM(C::Cn, v::T)

Constructor. All the matrix elements are set to be `v`.
"""
function CnLessM(C::Cn, v::T) where {T}
    CnLessM(C.ntime, C.ndim1, C.ndim2, v)
end

"""
    CnLessM(C::Cn)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLessM(C::Cn)
    CnLessM(C.ntime, C.ndim1, C.ndim2, CZERO)
end

#=
### *CnLessM* : *Properties*
=#

"""
    getdims(less::CnLessM{T})

Return the dimensional parameters of contour function.

See also: [`CnLessM`](@ref).
"""
function getdims(less::CnLessM{T}) where {T}
    return (less.ndim1, less.ndim2)
end

"""
    getsize(less::CnLessM{T})

Return the size of contour function.

See also: [`CnLessM`](@ref).
"""
function getsize(less::CnLessM{T}) where {T}
    return less.ntime
end

"""
    equaldims(less::CnLessM{T})

Return whether the dimensional parameters are equal.

See also: [`CnLessM`](@ref).
"""
function equaldims(less::CnLessM{T}) where {T}
    return less.ndim1 == less.ndim2
end

"""
    iscompatible(less1::CnLessM{T}, less2::CnLessM{T})

Judge whether two `CnLessM` objects are compatible.
"""
function iscompatible(less1::CnLessM{T}, less2::CnLessM{T}) where {T}
    getsize(less1) == getsize(less2) &&
    getdims(less1) == getdims(less2)
end

"""
    iscompatible(C::Cn, less::CnLessM{T})

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `CnLessM{T}` object).
"""
function iscompatible(C::Cn, less::CnLessM{T}) where {T}
    C.ntime == getsize(less) &&
    getdims(C) == getdims(less)
end

"""
    iscompatible(less::CnLessM{T}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `CnLessM{T}` object).
"""
iscompatible(less::CnLessM{T}, C::Cn) where {T} = iscompatible(C, less)

"""
    distance(less1::CnLessM{T}, less2::CnLessM{T}, tstp::I64)

Calculate distance between two `CnLessM` objects at given time step `tstp`.
"""
function distance(less1::CnLessM{T}, less2::CnLessM{T}, tstp::I64) where {T}
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
### *CnLessM* : *Indexing*
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
    Base.getindex(less::CnLessM{T}, i::I64, j::I64)

Visit the element stored in `CnLessM` object.
"""
function Base.getindex(less::CnLessM{T}, i::I64, j::I64) where {T}
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
    Base.setindex!(less::CnLessM{T}, x::Element{T}, i::I64, j::I64)

Setup the element in `CnLessM` object.
"""
function Base.setindex!(less::CnLessM{T}, x::Element{T}, i::I64, j::I64) where {T}
    # Sanity check
    @assert size(x) == getdims(less)
    @assert 1 ≤ i ≤ less.ntime
    @assert 1 ≤ j ≤ less.ntime

    # G^{<}(tᵢ, tⱼ) = x
    less.data[i,j] = copy(x)
end

"""
    Base.setindex!(less::CnLessM{T}, v::T, i::I64, j::I64)

Setup the element in `CnLessM` object.
"""
function Base.setindex!(less::CnLessM{T}, v::T, i::I64, j::I64) where {T}
    # Sanity check
    @assert 1 ≤ i ≤ less.ntime
    @assert 1 ≤ j ≤ less.ntime

    # G^{<}(tᵢ, tⱼ) .= v
    fill!(less.data[i,j], v)
end

#=
### *CnLessM* : *Operations*
=#

"""
    memset!(less::CnLessM{T}, x)

Reset all the matrix elements of `less` to `x`. `x` should be a
scalar number.
"""
function memset!(less::CnLessM{T}, x) where {T}
    cx = convert(T, x)
    for i=1:less.ntime
        for j=1:less.ntime
            fill!(less.data[j,i], cx)
        end
    end
end

"""
    memset!(less::CnLessM{T}, tstp::I64, x)

Reset the matrix elements of `less` at given time step `tstp` to `x`. `x`
should be a scalar number.
"""
function memset!(less::CnLessM{T}, tstp::I64, x) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    cx = convert(T, x)
    for i=1:tstp
        fill!(less.data[i,tstp], cx)
    end
end

"""
    zeros!(less::CnLessM{T})

Reset all the matrix elements of `less` to `ZERO`.
"""
zeros!(less::CnLessM{T}) where {T} = memset!(less, zero(T))

"""
    zeros!(less::CnLessM{T}, tstp::I64)

Reset the matrix elements of `less` at given time step `tstp` to `ZERO`.
"""
zeros!(less::CnLessM{T}, tstp::I64) where {T} = memset!(less, tstp, zero(T))

"""
    memcpy!(src::CnLessM{T}, dst::CnLessM{T})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnLessM{T}, dst::CnLessM{T}) where {T}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::CnLessM{T}, dst::CnLessM{T}, tstp::I64)

Copy some matrix elements from `src` to `dst`. Only the matrix elements
at given time step `tstp` are copied.
"""
function memcpy!(src::CnLessM{T}, dst::CnLessM{T}, tstp::I64) where {T}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    for i=1:tstp
        dst.data[i,tstp] = copy(src.data[i,tstp])
    end
end

"""
    incr!(less1::CnLessM{T}, less2::CnLessM{T}, tstp::I64, alpha::T)

Add a `CnLessM` with given weight (`alpha`) at given time step `tstp` to
another `CnLessM`.
"""
function incr!(less1::CnLessM{T}, less2::CnLessM{T}, tstp::I64, alpha::T) where {T}
    @assert iscompatible(less1, less2)
    @assert 1 ≤ tstp ≤ less2.ntime
    for i = 1:tstp
        @. less1.data[i,tstp] = less1.data[i,tstp] + less2.data[i,tstp] * alpha
    end
end

"""
    smul!(less::CnLessM{T}, tstp::I64, alpha::T)

Multiply a `CnLessM` with given weight (`alpha`) at given time
step `tstp`.
"""
function smul!(less::CnLessM{T}, tstp::I64, alpha::T) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    for i = 1:tstp
        @. less.data[i,tstp] = less.data[i,tstp] * alpha
    end
end

"""
    smul!(x::CnFunF{T}, less::CnLessM{T}, tstp::I64)

Left multiply a `CnLessM` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(x::CnFunF{T}, less::CnLessM{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    for i = 1:tstp
        less.data[i,tstp] = x[i] * less.data[i,tstp]
    end
end

"""
    smul!(less::CnLessM{T}, x::Element{T}, tstp::I64)

Right multiply a `CnLessM` with given weight (`x`) at given time
step `tstp`.
"""
function smul!(less::CnLessM{T}, x::Element{T}, tstp::I64) where {T}
    @assert 1 ≤ tstp ≤ less.ntime
    for i = 1:tstp
        less.data[i,tstp] = less.data[i,tstp] * x
    end
end

#=
### *CnLessM* : *Traits*
=#

"""
    Base.:+(less1::CnLessM{T}, less2::CnLessM{T})

Operation `+` for two `CnLessM` objects.
"""
function Base.:+(less1::CnLessM{T}, less2::CnLessM{T}) where {T}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    CnLessM(less1.ntime, less1.ndim1, less1.ndim2, less1.data + less2.data)
end

"""
    Base.:-(less1::CnLessM{T}, less2::CnLessM{T})

Operation `-` for two `CnLessM` objects.
"""
function Base.:-(less1::CnLessM{T}, less2::CnLessM{T}) where {T}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    CnLessM(less1.ntime, less1.ndim1, less1.ndim2, less1.data - less2.data)
end

"""
    Base.:*(less::CnLessM{T}, x)

Operation `*` for a `CnLessM` object and a scalar value.
"""
function Base.:*(less::CnLessM{T}, x) where {T}
    cx = convert(T, x)
    CnLessM(less.ntime, less.ndim1, less.ndim2, less.data * cx)
end

"""
    Base.:*(x, less::CnLessM{T})

Operation `*` for a scalar value and a `CnLessM` object.
"""
Base.:*(x, less::CnLessM{T}) where {T} = Base.:*(less, x)

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
### *CnGtrM* : *Struct*
=#

"""
    CnGtrM{T}

Greater component (``G^{>}``) of contour Green's function.

See also: [`CnRetM`](@ref), [`CnLmixM`](@ref), [`CnLessM`](@ref).
"""
mutable struct CnGtrM{T} <: CnAbsMat{T}
    ntime :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataL :: Ref{CnLessM{T}}
    dataR :: Ref{CnRetM{T}}
end

#=
### *CnGtrM* : *Constructors*
=#

"""
    CnGtrM(less::CnLessM{T}, ret::CnRetM{T})

Constructor. Note that the `gtr` component is not independent. We use
the `less` and `ret` components to initialize it.
"""
function CnGtrM(less::CnLessM{T}, ret::CnRetM{T}) where {T}
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
    CnGtrM(ntime, ndim1, ndim2, dataL, dataR)
end

#=
### *CnGtrM* : *Indexing*
=#

"""
    Base.getindex(gtr::CnGtrM{T}, i::I64, j::I64)

Visit the element stored in `CnGtrM` object.
"""
function Base.getindex(gtr::CnGtrM{T}, i::I64, j::I64) where {T}
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
### *CnFunM* : *Struct*
=#

"""
    CnFunM{T}

Standard contour-ordered Green's function. It includes four independent
components, namely `mat`, `ret`, `lmix`, and `less`.
"""
mutable struct CnFunM{T} <: CnAbsFun{T}
    sign :: I64 # Used to distinguish fermions and bosons
    mat  :: CnMatM{T}
    ret  :: CnRetM{T}
    lmix :: CnLmixM{T}
    less :: CnLessM{T}
end

#=
### *CnFunM* : *Constructors*
=#

"""
    CnFunM(C::Cn, v::T, sign::I64)

Standard constructor. This function is initialized by `v`.
"""
function CnFunM(C::Cn, v::T, sign::I64) where {T}
    # Sanity check
    @assert sign in (BOSE, FERMI)

    # Create mat, ret, lmix, and less.
    mat  = CnMatM(C, v)
    ret  = CnRetM(C, v)
    lmix = CnLmixM(C, v)
    less = CnLessM(C, v)

    # Call the default constructor
    CnFunM(sign, mat, ret, lmix, less)
end

"""
    CnFunM(C::Cn, sign::I64 = FERMI)

Constructor. Create a contour Green's function with zero initial values.
"""
function CnFunM(C::Cn, sign::I64 = FERMI)
    # Setup sign
    @assert sign in (BOSE, FERMI)

    # Create mat, ret, lmix, and less.
    mat  = CnMatM(C)
    ret  = CnRetM(C)
    lmix = CnLmixM(C)
    less = CnLessM(C)

    # Call the default constructor
    CnFunM(sign, mat, ret, lmix, less)
end

#=
### *CnFunM* : *Properties*
=#

"""
    getdims(cfm::CnFunM{T})

Return the dimensional parameters of contour Green's function.

See also: [`CnFunM`](@ref).
"""
function getdims(cfm::CnFunM{T}) where {T}
    return getdims(cfm.less)
end

"""
    getntime(cfm::CnFunM{T})

Return the `ntime` parameter of contour Green's function.
"""
function getntime(cfm::CnFunM{T}) where {T}
    return getsize(cfm.less)
end

"""
    getntau(cfm::CnFunM{T})

Return the `ntau` parameter of contour Green's function.
"""
function getntau(cfm::CnFunM{T}) where {T}
    return getsize(cfm.mat)
end

"""
    getsign(cfm::CnFunM{T})

Return the `sign` parameter of contour Green's function.
"""
function getsign(cfm::CnFunM{T}) where {T}
    return cfm.sign
end

"""
    equaldims(cfm::CnFunM{T})

Return whether the dimensional parameters are equal.

See also: [`CnFunM`](@ref).
"""
function equaldims(cfm::CnFunM{T}) where {T}
    return equaldims(cfm.less)
end

"""
    density(cfm::CnFunM{T}, tstp::I64)

Returns the density matrix at given time step `tstp`. If `tstp = 0`,
it denotes the equilibrium state. However, when `tstp > 0`, it means
the nonequilibrium state.

See also: [`CnMatM`](@ref), [`CnLessM`](@ref).
"""
function density(cfm::CnFunM{T}, tstp::I64) where {T}
    # Sanity check
    @assert 0 ≤ tstp ≤ getntime(cfm)

    if tstp == 0
        return -cfm.mat[getntime(cfm)]
    else
        return cfm.less[tstp, tstp] * getsign(cfm) * CZI
    end
end

"""
    distance(cfm1::CnFunM{T}, cfm2::CnFunM{T}, tstp::I64)

Calculate distance between two `CnFunM` objects at given time step `tstp`.
"""
function distance(cfm1::CnFunM{T}, cfm2::CnFunM{T}, tstp::I64) where {T}
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
### *CnFunM* : *Operations*
=#

"""
    memset!(cfm::CnFunM{T}, x)

Reset all the matrix elements of `cfm` to `x`. `x` should be a
scalar number.
"""
function memset!(cfm::CnFunM{T}, x) where {T}
    memset!(cfm.mat, x)
    memset!(cfm.ret, x)
    memset!(cfm.lmix, x)
    memset!(cfm.less, x)
end

"""
    memset!(cfm::CnFunM{T}, tstp::I64, x)

Reset the matrix elements of `cfm` at given time step `tstp` to `x`. `x`
should be a scalar number. Note that `tstp = 0` means the equilibrium
state, at this time this function will reset the Matsubara component
only. However, when `tstp > 0`, the `ret`, `lmix`, and `less` components
will be changed.
"""
function memset!(cfm::CnFunM{T}, tstp::I64, x) where {T}
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
    zeros!(cfm::CnFunM{T})

Reset all the matrix elements of `cfm` to `ZERO`.
"""
zeros!(cfm::CnFunM{T}) where {T} = memset!(cfm, zero(T))

"""
    zeros!(cfm::CnFunM{T}, tstp::I64)

Reset the matrix elements of `cfm` at given time step `tstp` to `ZERO`.
"""
zeros!(cfm::CnFunM{T}, tstp::I64) where {T} = memset!(cfm, tstp, zero(T))

"""
    memcpy!(src::CnFunM{T}, dst::CnFunM{T}, tstp::I64)

Copy contour Green's function at given time step `tstp`. Note that
`tstp = 0` means the equilibrium state, at this time this function
will copy the Matsubara component only. However, when `tstp > 0`,
the `ret`, `lmix`, and `less` components will be copied.
"""
function memcpy!(src::CnFunM{T}, dst::CnFunM{T}, tstp::I64) where {T}
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
    incr!(cfm1::CnFunM{T}, cfm2::CnFunM{T}, tstp::I64, alpha)

Adds a `CnFunM` with given weight (`alpha`) to another `CnFunM` (at given
time step `tstp`).
"""
function incr!(cfm1::CnFunM{T}, cfm2::CnFunM{T}, tstp::I64, alpha) where {T}
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
    incr!(cfm1::CnFunM{T}, cfm2::CnFunM{T}, alpha)

Adds a `CnFunM` with given weight (`alpha`) to another `CnFunM` (at all
possible time step `tstp`).
"""
function incr!(cfm1::CnFunM{T}, cfm2::CnFunM{T}, alpha) where {T}
    for tstp = 0:getntime(cfm2)
        incr!(cfm1, cfm2, tstp, alpha)
    end
end

"""
    smul!(cfm::CnFunM{T}, tstp::I64, alpha)

Multiply a `CnFunM` with given weight (`alpha`) at given time
step `tstp`.
"""
function smul!(cfm::CnFunM{T}, tstp::I64, alpha) where {T}
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
    smul!(cff::CnFunF{T}, cfm::CnFunM{T}, tstp::I64)

Left multiply a `CnFunM` with given weight (`CnFunF`) at given time
step `tstp`.
"""
function smul!(cff::CnFunF{T}, cfm::CnFunM{T}, tstp::I64) where {T}
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
    smul!(cfm::CnFunM{T}, cff::CnFunF{T}, tstp::I64)

Right multiply a `CnFunM` with given weight (`CnFunF`) at given time
step `tstp`.
"""
function smul!(cfm::CnFunM{T}, cff::CnFunF{T}, tstp::I64) where {T}
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
### *CnFunM* : *I/O*
=#

"""
    read!(fname::AbstractString, cfm::CnFunM{T})

Read the contour Green's functions from given file.
"""
function read!(fname::AbstractString, cfm::CnFunM{T}) where {T}
end

"""
    write(fname::AbstractString, cfm::CnFunM{T})

Write the contour Green's functions to given file.
"""
function write(fname::AbstractString, cfm::CnFunM{T}) where {T}
end

#=
### *CnFunM* : *Traits*
=#

"""
    Base.getproperty(cfm::CnFunM{T}, symbol::Symbol)

Visit the properties stored in `CnFunM` object. It provides access to
the Matsubara (minus, `matm`), advanced (`adv`), right-mixing (`rmix`),
and greater (`gtr`) components of the contour-ordered Green's function.
"""
function Base.getproperty(cfm::CnFunM{T}, symbol::Symbol) where {T}
    if symbol === :matm
        return CnMatmM(cfm.sign, cfm.mat)
    #
    elseif symbol === :adv
        error("Sorry, this feature has not been implemented")
    #
    elseif symbol === :rmix
        return CnRmixM(cfm.sign, cfm.lmix)
    #
    elseif symbol === :gtr
        return CnGtrM(cfm.less, cfm.ret)
    #
    else # Fallback to getfield()
        return getfield(cfm, symbol)
    end
end

#=
### *CnMatV* : *Struct*
=#

"""
    CnMatV{S}

Matsubara component (``G^{M}``) of contour Green's function at given
time step `tstp`. Actually, `CnMatV{S}` is equivalent to `CnMatM{T}`.

See also: [`CnRetV`](@ref), [`CnLmixV`](@ref), [`CnLessV`](@ref).
"""
mutable struct CnMatV{S} <: CnAbsVec{S}
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{S}
end

#=
### *CnMatV* : *Constructors*
=#

"""
    CnMatV(ntau::I64, ndim1::I64, ndim2::I64, v::S)

Constructor. All the vector elements are set to be `v`.
"""
function CnMatV(ntau::I64, ndim1::I64, ndim2::I64, v::S) where {S}
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
    CnMatV(ntau, ndim1, ndim2, data)
end

"""
    CnMatV(ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the vector elements are set to be `CZERO`.
"""
function CnMatV(ntau::I64, ndim1::I64, ndim2::I64)
    CnMatV(ntau, ndim1, ndim2, CZERO)
end

"""
    CnMatV(ntau::I64, ndim1::I64)

Constructor. All the vector elements are set to be `CZERO`.
"""
function CnMatV(ntau::I64, ndim1::I64)
    CnMatV(ntau, ndim1, ndim1, CZERO)
end

"""
    CnMatV(ntau::I64, x::Element{S})

Constructor. The vector is initialized by `x`.
"""
function CnMatV(ntau::I64, x::Element{S}) where {S}
    # Sanity check
    @assert ntau ≥ 2

    ndim1, ndim2 = size(x)
    data = VecArray{S}(undef, ntau)
    for i = 1:ntau
        data[i] = copy(x)
    end

    # Call the default constructor
    CnMatV(ntau, ndim1, ndim2, data)
end

#=
### *CnMatV* : *Properties*
=#

"""
    getdims(mat::CnMatV{S})

Return the dimensional parameters of contour function.

See also: [`CnMatV`](@ref).
"""
function getdims(mat::CnMatV{S}) where {S}
    return (mat.ndim1, mat.ndim2)
end

"""
    getsize(mat::CnMatV{S})

Return the size of contour function.

See also: [`CnMatV`](@ref).
"""
function getsize(mat::CnMatV{S}) where {S}
    return mat.ntau
end

"""
    equaldims(mat::CnMatV{S})

Return whether the dimensional parameters are equal.

See also: [`CnMatV`](@ref).
"""
function equaldims(mat::CnMatV{S}) where {S}
    return mat.ndim1 == mat.ndim2
end

"""
    iscompatible(mat1::CnMatV{S}, mat2::CnMatV{S})

Judge whether two `CnMatV` objects are compatible.
"""
function iscompatible(mat1::CnMatV{S}, mat2::CnMatV{S}) where {S}
    getsize(mat1) == getsize(mat2) &&
    getdims(mat1) == getdims(mat2)
end

"""
    iscompatible(mat1::CnMatV{S}, mat2::CnMatM{S})

Judge whether the `CnMatV` and `CnMatM` objects are compatible.
"""
function iscompatible(mat1::CnMatV{S}, mat2::CnMatM{S}) where {S}
    getsize(mat1) == getsize(mat2) &&
    getdims(mat1) == getdims(mat2)
end

"""
    iscompatible(mat1::CnMatM{S}, mat2::CnMatV{S})

Judge whether the `CnMatV` and `CnMatM` objects are compatible.
"""
iscompatible(mat1::CnMatM{S}, mat2::CnMatV{S}) where {S} = iscompatible(mat2, mat1)

"""
    iscompatible(C::Cn, mat::CnMatV{S})

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `CnMatV{S}` object).
"""
function iscompatible(C::Cn, mat::CnMatV{S}) where {S}
    C.ntau == getsize(mat) &&
    getdims(C) == getdims(mat)
end

"""
    iscompatible(mat::CnMatV{S}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `mat`
(which is a `CnMatV{S}` object).
"""
iscompatible(mat::CnMatV{S}, C::Cn) where {S} = iscompatible(C, mat)

"""
    distance(mat1::CnMatV{S}, mat2::CnMatV{S})

Calculate distance between two `CnMatV` objects.
"""
function distance(mat1::CnMatV{S}, mat2::CnMatV{S}) where {S}
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
    distance(mat1::CnMatV{S}, mat2::CnMatM{S})

Calculate distance between a `CnMatV` object and a `CnMatM` object.
"""
function distance(mat1::CnMatV{S}, mat2::CnMatM{S}) where {S}
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
    distance(mat1::CnMatM{S}, mat2::CnMatV{S})

Calculate distance between a `CnMatV` object and a `CnMatM` object.
"""
distance(mat1::CnMatM{S}, mat2::CnMatV{S}) where {S} = distance(mat2, mat1)

#=
### *CnMatV* : *Indexing*
=#

"""
    Base.getindex(mat::CnMatV{S}, ind::I64)

Visit the element stored in `CnMatV` object.
"""
function Base.getindex(mat::CnMatV{S}, ind::I64) where {S}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # Return G^{M}(τᵢ)
    mat.data[ind]
end

"""
    Base.setindex!(mat::CnMatV{S}, x::Element{S}, ind::I64)

Setup the element in `CnMatV` object.
"""
function Base.setindex!(mat::CnMatV{S}, x::Element{S}, ind::I64) where {S}
    # Sanity check
    @assert size(x) == getdims(mat)
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) = x
    mat.data[ind] = copy(x)
end

"""
    Base.setindex!(mat::CnMatV{S}, v::S, ind::I64)

Setup the element in `CnMatV` object.
"""
function Base.setindex!(mat::CnMatV{S}, v::S, ind::I64) where {S}
    # Sanity check
    @assert 1 ≤ ind ≤ mat.ntau

    # G^{M}(τᵢ) .= v
    fill!(mat.data[ind], v)
end

#=
### *CnMatV* : *Operations*
=#

"""
    memset!(mat::CnMatV{S}, x)

Reset all the vector elements of `mat` to `x`. `x` should be a
scalar number.
"""
function memset!(mat::CnMatV{S}, x) where {S}
    cx = convert(S, x)
    for i = 1:mat.ntau
        fill!(mat.data[i], cx)
    end
end

"""
    zeros!(mat::CnMatV{S})

Reset all the vector elements of `mat` to `ZERO`.
"""
zeros!(mat::CnMatV{S}) where {S} = memset!(mat, zero(S))

"""
    memcpy!(src::CnMatV{S}, dst::CnMatV{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnMatV{S}, dst::CnMatV{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::CnMatM{S}, dst::CnMatV{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnMatM{S}, dst::CnMatV{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data[:,1])
end

"""
    memcpy!(src::CnMatV{S}, dst::CnMatM{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnMatV{S}, dst::CnMatM{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data[:,1] = copy(src.data)
end

"""
    incr!(mat1::CnMatV{S}, mat2::CnMatV{S}, alpha::S)

Add a `CnMatV` with given weight (`alpha`) to another `CnMatV`.
"""
function incr!(mat1::CnMatV{S}, mat2::CnMatV{S}, alpha::S) where {S}
    @assert iscompatible(mat1, mat2)
    for i = 1:mat2.ntau
        @. mat1.data[i] = mat1.data[i] + mat2.data[i] * alpha
    end
end

"""
    incr!(mat1::CnMatM{S}, mat2::CnMatV{S}, alpha::S)

Add a `CnMatV` with given weight (`alpha`) to a `CnMatM`.
"""
function incr!(mat1::CnMatM{S}, mat2::CnMatV{S}, alpha::S) where {S}
    @assert iscompatible(mat1, mat2)
    for i = 1:mat2.ntau
        @. mat1.data[i,1] = mat1.data[i,1] + mat2.data[i] * alpha
    end
end

"""
    incr!(mat1::CnMatV{S}, mat2::CnMatM{S}, alpha::S)

Add a `CnMatM` with given weight (`alpha`) to a `CnMatV`.
"""
function incr!(mat1::CnMatV{S}, mat2::CnMatM{S}, alpha::S) where {S}
    @assert iscompatible(mat1, mat2)
    for i = 1:mat1.ntau
        @. mat1.data[i] = mat1.data[i] + mat2.data[i,1] * alpha
    end
end

"""
    smul!(mat::CnMatV{S}, alpha::S)

Multiply a `CnMatV` with given weight (`alpha`).
"""
function smul!(mat::CnMatV{S}, alpha::S) where {S}
    for i = 1:mat.ntau
        @. mat.data[i] = mat.data[i] * alpha
    end
end

"""
    smul!(x::Element{S}, mat::CnMatV{S})

Left multiply a `CnMatV` with given weight (`x`).
"""
function smul!(x::Element{S}, mat::CnMatV{S}) where {S}
    for i = 1:mat.ntau
        mat.data[i] = x * mat.data[i]
    end
end

"""
    smul!(mat::CnMatV{S}, x::Element{S})

Right multiply a `CnMatV` with given weight (`x`).
"""
function smul!(mat::CnMatV{S}, x::Element{S}) where {S}
    for i = 1:mat.ntau
        mat.data[i] = mat.data[i] * x
    end
end

#=
### *CnMatV* : *Traits*
=#

"""
    Base.:+(mat1::CnMatV{S}, mat2::CnMatV{S})

Operation `+` for two `CnMatV` objects.
"""
function Base.:+(mat1::CnMatV{S}, mat2::CnMatV{S}) where {S}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    CnMatV(mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data + mat2.data)
end

"""
    Base.:-(mat1::CnMatV{S}, mat2::CnMatV{S})

Operation `-` for two `CnMatV` objects.
"""
function Base.:-(mat1::CnMatV{S}, mat2::CnMatV{S}) where {S}
    # Sanity check
    @assert getsize(mat1) == getsize(mat2)
    @assert getdims(mat1) == getdims(mat2)

    CnMatV(mat1.ntau, mat1.ndim1, mat1.ndim2, mat1.data - mat2.data)
end

"""
    Base.:*(mat::CnMatV{S}, x)

Operation `*` for a `CnMatV` object and a scalar value.
"""
function Base.:*(mat::CnMatV{S}, x) where {S}
    cx = convert(S, x)
    CnMatV(mat.ntau, mat.ndim1, mat.ndim2, mat.data * cx)
end

"""
    Base.:*(x, mat::CnMatV{S})

Operation `*` for a scalar value and a `CnMatV` object.
"""
Base.:*(x, mat::CnMatV{S}) where {S} = Base.:*(mat, x)

#=
### *CnMatmV* : *Struct*
=#

"""
    CnMatmV{S}

Matsubara component (``G^M``) of contour Green's function at given time
step `tstp = 0`. It is designed for ``\tau < 0`` case. It is not an
independent component. It can be constructed from the `CnMatV{T}` struct.

See also: [`CnRetM`](@ref), [`CnLmixM`](@ref), [`CnLessM`](@ref).
"""
mutable struct CnMatmV{S} <: CnAbsVec{S}
    sign  :: I64 # Used to distinguish fermions and bosons
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataV :: Ref{CnMatV{S}}
end

#=
### *CnMatmV* : *Constructors*
=#

"""
    CnMatmV(sign::I64, mat::CnMatV{S})

Constructor. Note that the `matm` component is not independent. We use
the `mat` component to initialize it.
"""
function CnMatmV(sign::I64, mat::CnMatV{S}) where {S}
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
    CnMatmV(sign, ntau, ndim1, ndim2, dataV)
end

#=
### *CnMatmV* : *Indexing*
=#

"""
    Base.getindex(matm::CnMatmV{S}, ind::I64)

Visit the element stored in `CnMatmV` object.
"""
function Base.getindex(matm::CnMatmV{S}, ind::I64) where {S}
    # Sanity check
    @assert 1 ≤ ind ≤ matm.ntau

    # Return G^{M}(τᵢ < 0)
    matm.dataV[][matm.ntau - ind + 1] * matm.sign
end

#=
### *CnRetV* : *Struct*
=#

"""
    CnRetV{S}

Retarded component (``G^{R}``) of contour Green's function at given
time step `tstp`. Actually, it denotes ``G^{R}(tᵢ = tstp, tⱼ)``.

See also: [`CnMatV`](@ref), [`CnLmixV`](@ref), [`CnLessV`](@ref).
"""
mutable struct CnRetV{S} <: CnAbsVec{S}
    tstp  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{S}
end

#=
### *CnRetV* : *Constructors*
=#

"""
    CnRetV(tstp::I64, ndim1::I64, ndim2::I64, v::S) where {S}

Constructor. All the vector elements are set to be `v`.
"""
function CnRetV(tstp::I64, ndim1::I64, ndim2::I64, v::S) where {S}
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
    CnRetV(tstp, ndim1, ndim2, data)
end

"""
    CnRetV(tstp::I64, ndim1::I64, ndim2::I64)

Constructor. All the vector elements are set to be `CZERO`.
"""
function CnRetV(tstp::I64, ndim1::I64, ndim2::I64)
    CnRetV(tstp, ndim1, ndim2, CZERO)
end

"""
    CnRetV(tstp::I64, ndim1::I64)

Constructor. All the vector elements are set to be `CZERO`.
"""
function CnRetV(tstp::I64, ndim1::I64)
    CnRetV(tstp, ndim1, ndim1, CZERO)
end

"""
    CnRetV(tstp::I64, x::Element{S})

Constructor. The vector is initialized by `x`.
"""
function CnRetV(tstp::I64, x::Element{S}) where {S}
    # Sanity check
    @assert tstp ≥ 1

    ndim1, ndim2 = size(x)
    data = VecArray{S}(undef, tstp)
    for i = 1:tstp
        data[i] = copy(x)
    end

    # Call the default constructor
    CnRetV(tstp, ndim1, ndim2, data)
end

#=
### *CnRetV* : *Properties*
=#

"""
    getdims(ret::CnRetV{S})

Return the dimensional parameters of contour function.

See also: [`CnRetV`](@ref).
"""
function getdims(ret::CnRetV{S}) where {S}
    return (ret.ndim1, ret.ndim2)
end

"""
    getsize(ret::CnRetV{S})

Return the size of contour function.

See also: [`CnRetV`](@ref).
"""
function getsize(ret::CnRetV{S}) where {S}
    return ret.tstp
end

"""
    equaldims(ret::CnRetV{S})

Return whether the dimensional parameters are equal.

See also: [`CnRetV`](@ref).
"""
function equaldims(ret::CnRetV{S}) where {S}
    return ret.ndim1 == ret.ndim2
end

"""
    iscompatible(ret1::CnRetV{S}, ret2::CnRetV{S})

Judge whether two `CnRetV` objects are compatible.
"""
function iscompatible(ret1::CnRetV{S}, ret2::CnRetV{S}) where {S}
    getsize(ret1) == getsize(ret2) &&
    getdims(ret1) == getdims(ret2)
end

"""
    iscompatible(ret1::CnRetV{S}, ret2::CnRetM{S})

Judge whether the `CnRetV` and `CnRetM` objects are compatible.
"""
function iscompatible(ret1::CnRetV{S}, ret2::CnRetM{S}) where {S}
    getsize(ret1) ≤ getsize(ret2) &&
    getdims(ret1) == getdims(ret2)
end

"""
    iscompatible(ret1::CnRetM{S}, ret2::CnRetV{S})

Judge whether the `CnRetV` and `CnRetM` objects are compatible.
"""
iscompatible(ret1::CnRetM{S}, ret2::CnRetV{S}) where {S} = iscompatible(ret2, ret1)

"""
    iscompatible(C::Cn, ret::CnRetV{S})

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `CnRetV{S}` object).
"""
function iscompatible(C::Cn, ret::CnRetV{S}) where {S}
    C.ntime ≥ getsize(ret) &&
    getdims(C) == getdims(ret)
end

"""
    iscompatible(ret::CnRetV{S}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `ret`
(which is a `CnRetV{S}` object).
"""
iscompatible(ret::CnRetV{S}, C::Cn) where {S} = iscompatible(C, ret)

"""
    distance(ret1::CnRetV{S}, ret2::CnRetV{S})

Calculate distance between two `CnRetV` objects.
"""
function distance(ret1::CnRetV{S}, ret2::CnRetV{S}) where {S}
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
    distance(ret1::CnRetV{S}, ret2::CnRetM{S}, tstp::I64)

Calculate distance between a `CnRetV` object and a `CnRetM` object at
given time step `tstp`.
"""
function distance(ret1::CnRetV{S}, ret2::CnRetM{S}, tstp::I64) where {S}
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
    distance(ret1::CnRetM{S}, ret2::CnRetV{S}, tstp::I64)

Calculate distance between a `CnRetV` object and a `CnRetM` object at
given time step `tstp`.
"""
distance(ret1::CnRetM{S}, ret2::CnRetV{S}, tstp::I64) where {S} = distance(ret2, ret1, tstp)

#=
### *CnRetV* : *Indexing*
=#

"""
    Base.getindex(ret::CnRetV{S}, j::I64)

Visit the element stored in `CnRetV` object. Here `j` is index for
real times.
"""
function Base.getindex(ret::CnRetV{S}, j::I64) where {S}
    # Sanity check
    @assert 1 ≤ j ≤ ret.tstp

    # Return G^{R}(tᵢ ≡ tstp, tⱼ)
    ret.data[j]
end

"""
    Base.getindex(ret::CnRetV{S}, i::I64, tstp::I64)

Visit the element stored in `CnRetV` object. Here `i` is index for
real times.
"""
function Base.getindex(ret::CnRetV{S}, i::I64, tstp::I64) where {S}
    # Sanity check
    @assert tstp == ret.tstp
    @assert 1 ≤ i ≤ ret.tstp

    # Return G^{R}(tᵢ, tⱼ ≡ tstp)
    -(ret.data[j])'
end

"""
    Base.setindex!(ret::CnRetV{S}, x::Element{S}, j::I64)

Setup the element in `CnRetV` object.
"""
function Base.setindex!(ret::CnRetV{S}, x::Element{S}, j::I64) where {S}
    # Sanity check
    @assert size(x) == getdims(ret)
    @assert 1 ≤ j ≤ ret.tstp

    # G^{R}(tᵢ ≡ tstp, tⱼ) = x
    ret.data[j] = copy(x)
end

"""
    Base.setindex!(ret::CnRetV{S}, v::S, j::I64)

Setup the element in `CnRetV` object.
"""
function Base.setindex!(ret::CnRetV{S}, v::S, j::I64) where {S}
    # Sanity check
    @assert 1 ≤ j ≤ ret.tstp

    # G^{R}(tᵢ ≡ tstp, tⱼ) .= v
    fill!(ret.data[j], v)
end

#=
### *CnRetV* : *Operations*
=#

"""
    memset!(ret::CnRetV{S}, x)

Reset all the vector elements of `ret` to `x`. `x` should be a
scalar number.
"""
function memset!(ret::CnRetV{S}, x) where {S}
    cx = convert(T, x)
    for i=1:ret.tstp
        fill!(ret.data[i], cx)
    end
end

"""
    zeros!(ret::CnRetV{S})

Reset all the vector elements of `ret` to `ZERO`.
"""
zeros!(ret::CnRetV{S}) where {S} = memset!(ret, zero(S))

"""
    memcpy!(src::CnRetV{S}, dst::CnRetV{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnRetV{S}, dst::CnRetV{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::CnRetM{S}, dst::CnRetV{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnRetM{S}, dst::CnRetV{S}) where {S}
    @assert iscompatible(src, dst)
    tstp = dst.tstp
    @. dst.data = copy(src.data[tstp,1:tstp])
end

"""
    memcpy!(src::CnRetV{S}, dst::CnRetM{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnRetV{S}, dst::CnRetM{S}) where {S}
    @assert iscompatible(src, dst)
    tstp = src.tstp
    @. dst.data[tstp,1:tstp] = copy(src.data)
end

"""
    incr!(ret1::CnRetV{S}, ret2::CnRetV{S}, alpha::S)

Add a `CnRetV` with given weight (`alpha`) to another `CnRetV`.
"""
function incr!(ret1::CnRetV{S}, ret2::CnRetV{S}, alpha::S) where {S}
    @assert iscompatible(ret1, ret2)
    tstp = ret2.tstp
    for i = 1:tstp
        @. ret1.data[i] = ret1.data[i] + ret2.data[i] * alpha
    end
end

"""
    incr!(ret1::CnRetM{S}, ret2::CnRetV{S}, alpha::S)

Add a `CnRetV` with given weight (`alpha`) to a `CnRetM`.
"""
function incr!(ret1::CnRetM{S}, ret2::CnRetV{S}, alpha::S) where {S}
    @assert iscompatible(ret1, ret2)
    tstp = ret2.tstp
    for i = 1:tstp
        @. ret1.data[tstp,i] = ret1.data[tstp,i] + ret2.data[i] * alpha
    end
end

"""
    incr!(ret1::CnRetV{S}, ret2::CnRetM{S}, alpha::S)

Add a `CnRetM` with given weight (`alpha`) to a `CnRetV`.
"""
function incr!(ret1::CnRetV{S}, ret2::CnRetM{S}, alpha::S) where {S}
    @assert iscompatible(ret1, ret2)
    tstp = ret1.tstp
    for i = 1:tstp
        @. ret1.data[i] = ret1.data[i] + ret2.data[tstp,i] * alpha
    end
end

"""
    smul!(ret::CnRetV{S}, alpha::S)

Multiply a `CnRetV` with given weight (`alpha`).
"""
function smul!(ret::CnRetV{S}, alpha::S) where {S}
    for i = 1:ret.tstp
        @. ret.data[i] = ret.data[i] * alpha
    end
end

"""
    smul!(x::Element{S}, ret::CnRetV{S})

Left multiply a `CnRetV` with given weight (`x`).
"""
function smul!(x::Element{S}, ret::CnRetV{S}) where {S}
    for i = 1:ret.tstp
        ret.data[i] = x * ret.data[i]
    end
end

"""
    smul!(ret::CnRetV{S}, x::CnFunF{S})

Right multiply a `CnRetV` with given weight (`x`).
"""
function smul!(ret::CnRetV{S}, x::CnFunF{S}) where {S}
    for i = 1:ret.tstp
        ret.data[i] = ret.data[i] * x[i]
    end
end

#=
### *CnRetV* : *Traits*
=#

"""
    Base.:+(ret1::CnRetV{S}, ret2::CnRetV{S})

Operation `+` for two `CnRetV` objects.
"""
function Base.:+(ret1::CnRetV{S}, ret2::CnRetV{S}) where {S}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    CnRetV(ret1.tstp, ret1.ndim1, ret1.ndim2, ret1.data + ret2.data)
end

"""
    Base.:-(ret1::CnRetV{S}, ret2::CnRetV{S})

Operation `-` for two `CnRetV` objects.
"""
function Base.:-(ret1::CnRetV{S}, ret2::CnRetV{S}) where {S}
    # Sanity check
    @assert getsize(ret1) == getsize(ret2)
    @assert getdims(ret1) == getdims(ret2)

    CnRetV(ret1.tstp, ret1.ndim1, ret1.ndim2, ret1.data - ret2.data)
end

"""
    Base.:*(ret::CnRetV{S}, x)

Operation `*` for a `CnRetV` object and a scalar value.
"""
function Base.:*(ret::CnRetV{S}, x) where {S}
    cx = convert(S, x)
    CnRetV(ret.tstp, ret.ndim1, ret.ndim2, ret.data * cx)
end

"""
    Base.:*(x, ret::CnRetV{S})

Operation `*` for a scalar value and a `CnRetV` object.
"""
Base.:*(x, ret::CnRetV{S}) where {S} = Base.:*(ret, x)

#=
### *CnAdvV* : *Struct*
=#

mutable struct CnAdvV{S} <: CnAbsVec{S} end

#=
### *CnLmixV* : *Struct*
=#

"""
    CnLmixV{S}

Left-mixing component (``G^{⌉}``) of contour Green's function at given
time step `tstp`. Actually, it denotes ``G^{⌉}(tᵢ ≡ tstp, τⱼ)``.

See also: [`CnMatV`](@ref), [`CnRetV`](@ref), [`CnLessV`](@ref).
"""
mutable struct CnLmixV{S} <: CnAbsVec{S}
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{S}
end

#=
### *CnLmixV* : *Constructors*
=#

"""
    CnLmixV(ntau::I64, ndim1::I64, ndim2::I64, v::S)

Constructor. All the matrix elements are set to be `v`.
"""
function CnLmixV(ntau::I64, ndim1::I64, ndim2::I64, v::S) where {S}
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
    CnLmixV(ntau, ndim1, ndim2, data)
end

"""
    CnLmixV(ntau::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLmixV(ntau::I64, ndim1::I64, ndim2::I64)
    CnLmixV(ntau, ndim1, ndim2, CZERO)
end

"""
    CnLmixV(ntau::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLmixV(ntau::I64, ndim1::I64)
    CnLmixV(ntau, ndim1, ndim1, CZERO)
end

"""
    CnLmixV(ntau::I64, x::Element{S})

Constructor. The matrix is initialized by `x`.
"""
function CnLmixV(ntau::I64, x::Element{S}) where {S}
    # Sanity check
    @assert ntau ≥ 2

    ndim1, ndim2 = size(x)
    data = VecArray{S}(undef, ntau)
    for i = 1:ntau
        data[i] = copy(x)
    end

    # Call the default constructor
    CnLmixV(ntau, ndim1, ndim2, data)
end

#=
### *CnLmixV* : *Properties*
=#

"""
    getdims(lmix::CnLmixV{S})

Return the dimensional parameters of contour function.

See also: [`CnLmixV`](@ref).
"""
function getdims(lmix::CnLmixV{S}) where {S}
    return (lmix.ndim1, lmix.ndim2)
end

"""
    getsize(lmix::CnLmixV{S})

Return the size of contour function.

See also: [`CnLmixV`](@ref).
"""
function getsize(lmix::CnLmixV{S}) where {S}
    return lmix.ntau
end

"""
    equaldims(lmix::CnLmixV{S})

Return whether the dimensional parameters are equal.

See also: [`CnLmixV`](@ref).
"""
function equaldims(lmix::CnLmixV{S}) where {S}
    return lmix.ndim1 == lmix.ndim2
end

"""
    iscompatible(lmix1::CnLmixV{S}, lmix2::CnLmixV{S})

Judge whether two `CnLmixV` objects are compatible.
"""
function iscompatible(lmix1::CnLmixV{S}, lmix2::CnLmixV{S}) where {S}
    getsize(lmix1) == getsize(lmix2) &&
    getdims(lmix1) == getdims(lmix2)
end

"""
    iscompatible(lmix1::CnLmixV{S}, lmix2::CnLmixM{S})

Judge whether the `CnLmixV` and `CnLmixM` objects are compatible.
"""
function iscompatible(lmix1::CnLmixV{S}, lmix2::CnLmixM{S}) where {S}
    getsize(lmix1) == lmix2.ntau &&
    getdims(lmix1) == getdims(lmix2)
end

"""
    iscompatible(lmix1::CnLmixM{S}, lmix2::CnLmixV{S})

Judge whether the `CnLmixV` and `CnLmixM` objects are compatible.
"""
iscompatible(lmix1::CnLmixM{S}, lmix2::CnLmixV{S}) where {S} = iscompatible(lmix2, lmix1)

"""
    iscompatible(C::Cn, lmix::CnLmixV{S})

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `CnLmixV{S}` object).
"""
function iscompatible(C::Cn, lmix::CnLmixV{S}) where {S}
    C.ntau == getsize(lmix) &&
    getdims(C) == getdims(lmix)
end

"""
    iscompatible(lmix::CnLmixV{S}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `lmix`
(which is a `CnLmixV{S}` object).
"""
iscompatible(lmix::CnLmixV{S}, C::Cn) where {S} = iscompatible(C, lmix)

"""
    distance(lmix1::CnLmixV{S}, lmix2::CnLmixV{S})

Calculate distance between two `CnLmixV` objects.
"""
function distance(lmix1::CnLmixV{S}, lmix2::CnLmixV{S}) where {S}
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
    distance(lmix1::CnLmixV{S}, lmix2::CnLmixM{S}, tstp::I64)

Calculate distance between a `CnLmixV` object and a `CnLmixM` object at
given time step `tstp`.
"""
function distance(lmix1::CnLmixV{S}, lmix2::CnLmixM{S}, tstp::I64) where {S}
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
    distance(lmix1::CnLmixM{S}, lmix2::CnLmixV{S}, tstp::I64)

Calculate distance between a `CnLmixV` object and a `CnLmixM` object at
given time step `tstp`.
"""
distance(lmix1::CnLmixM{S}, lmix2::CnLmixV{S}, tstp::I64) where {S} = distance(lmix2, lmix1, tstp)

#=
### *CnLmixV* : *Indexing*
=#

"""
    Base.getindex(lmix::CnLmixV{S}, j::I64)

Visit the element stored in `CnLmixV` object.
"""
function Base.getindex(lmix::CnLmixV{S}, j::I64) where {S}
    # Sanity check
    @assert 1 ≤ j ≤ lmix.ntau

    # Return G^{⌉}(tᵢ ≡ tstp, τⱼ)
    lmix.data[j]
end

"""
    Base.setindex!(lmix::CnLmixV{S}, x::Element{S}, j::I64)

Setup the element in `CnLmixV` object.
"""
function Base.setindex!(lmix::CnLmixV{S}, x::Element{S}, j::I64) where {S}
    # Sanity check
    @assert size(x) == getdims(lmix)
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ ≡ tstp, τⱼ) = x
    lmix.data[j] = copy(x)
end

"""
    Base.setindex!(lmix::CnLmixV{S}, v::S, j::I64)

Setup the element in `CnLmixV` object.
"""
function Base.setindex!(lmix::CnLmixV{S}, v::S, j::I64) where {S}
    # Sanity check
    @assert 1 ≤ j ≤ lmix.ntau

    # G^{⌉}(tᵢ ≡ tstp, τⱼ) .= v
    fill!(lmix.data[j], v)
end

#=
### *CnLmixV* : *Operations*
=#

"""
    memset!(lmix::CnLmixV{S}, x)

Reset all the matrix elements of `lmix` to `x`. `x` should be a
scalar number.
"""
function memset!(lmix::CnLmixV{S}, x) where {S}
    cx = convert(S, x)
    for i=1:lmix.ntau
        fill!(lmix.data[i], cx)
    end
end

"""
    zeros!(lmix::CnLmixV{S})

Reset all the matrix elements of `lmix` to `ZERO`.
"""
zeros!(lmix::CnLmixV{S}) where {S} = memset!(lmix, zero(S))

"""
    memcpy!(src::CnLmixV{S}, dst::CnLmixV{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnLmixV{S}, dst::CnLmixV{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::CnLmixM{S}, dst::CnLmixV{S}, tstp::I64)

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnLmixM{S}, dst::CnLmixV{S}, tstp::I64) where {S}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ src.ntime
    @. dst.data = copy(src.data[tstp,:])
end

"""
    memcpy!(src::CnLmixV{S}, dst::CnLmixM{S}, tstp::I64)

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnLmixV{S}, dst::CnLmixM{S}, tstp::I64) where {S}
    @assert iscompatible(src, dst)
    @assert 1 ≤ tstp ≤ dst.ntime
    @. dst.data[tstp,:] = copy(src.data)
end

"""
    incr!(lmix1::CnLmixV{S}, lmix2::CnLmixV{S}, alpha::S)

Add a `CnLmixV` with given weight (`alpha`) to another `CnLmixV`.
"""
function incr!(lmix1::CnLmixV{S}, lmix2::CnLmixV{S}, alpha::S) where {S}
    @assert iscompatible(lmix1, lmix2)
    for i = 1:lmix2.ntau
        @. lmix1.data[i] = lmix1.data[i] + lmix2.data[i] * alpha
    end
end

"""
    incr!(lmix1::CnLmixM{S}, lmix2::CnLmixV{S}, tstp::I64, alpha::S)

Add a `CnLmixV` with given weight (`alpha`) to a `CnLmixM`.
"""
function incr!(lmix1::CnLmixM{S}, lmix2::CnLmixV{S}, tstp::I64, alpha::S) where {S}
    @assert iscompatible(lmix1, lmix2)
    @assert 1 ≤ tstp ≤ lmix1.ntime
    for i = 1:lmix2.ntau
        @. lmix1.data[tstp,i] = lmix1.data[tstp,i] + lmix2.data[i] * alpha
    end
end

"""
    incr!(lmix1::CnLmixV{S}, lmix2::CnLmixM{S}, tstp::I64, alpha::S)

Add a `CnLmixM` with given weight (`alpha`) to a `CnLmixV`.
"""
function incr!(lmix1::CnLmixV{S}, lmix2::CnLmixM{S}, tstp::I64, alpha::S) where {S}
    @assert iscompatible(lmix1, lmix2)
    @assert 1 ≤ tstp ≤ lmix2.ntime
    for i = 1:lmix1.ntau
        @. lmix1.data[i] = lmix1.data[i] + lmix2.data[tstp,i] * alpha
    end
end

"""
    smul!(lmix::CnLmixV{S}, alpha::S)

Multiply a `CnLmixV` with given weight (`alpha`).
"""
function smul!(lmix::CnLmixV{S}, alpha::S) where {S}
    for i = 1:lmix.ntau
        @. lmix.data[i] = lmix.data[i] * alpha
    end
end

"""
    smul!(x::Element{S}, lmix::CnLmixV{S})

Left multiply a `CnLmixV` with given weight (`x`).
"""
function smul!(x::Element{S}, lmix::CnLmixV{S}) where {S}
    for i = 1:lmix.ntau
        lmix.data[i] = x * lmix.data[i]
    end
end

"""
    smul!(lmix::CnLmixV{S}, x::Element{S})

Right multiply a `CnLmixV` with given weight (`x`).
"""
function smul!(lmix::CnLmixV{S}, x::Element{S}) where {S}
    for i = 1:lmix.ntau
        lmix.data[i] = lmix.data[i] * x
    end
end

#=
### *CnLmixV* : *Traits*
=#

"""
    Base.:+(lmix1::CnLmixV{S}, lmix2::CnLmixV{S})

Operation `+` for two `CnLmixV` objects.
"""
function Base.:+(lmix1::CnLmixV{S}, lmix2::CnLmixV{S}) where {S}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    CnLmixV(lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data + lmix2.data)
end

"""
    Base.:-(lmix1::CnLmixV{S}, lmix2::CnLmixV{S})

Operation `-` for two `CnLmixV` objects.
"""
function Base.:-(lmix1::CnLmixV{S}, lmix2::CnLmixV{S}) where {S}
    # Sanity check
    @assert getsize(lmix1) == getsize(lmix2)
    @assert getdims(lmix1) == getdims(lmix2)

    CnLmixV(lmix1.ntau, lmix1.ndim1, lmix1.ndim2, lmix1.data - lmix2.data)
end

"""
    Base.:*(lmix::CnLmixV{S}, x)

Operation `*` for a `CnLmixV` object and a scalar value.
"""
function Base.:*(lmix::CnLmixV{S}, x) where {S}
    cx = convert(S, x)
    CnLmixV(lmix.ntau, lmix.ndim1, lmix.ndim2, lmix.data * cx)
end

"""
    Base.:*(x, lmix::CnLmixV{S})

Operation `*` for a scalar value and a `CnLmixV` object.
"""
Base.:*(x, lmix::CnLmixV{S}) where {S} = Base.:*(lmix, x)

#=
### *CnRmixV* : *Struct*
=#

"""
    CnRmixV{S}

Right-mixing component (``G^{⌈}``) of contour Green's function at given
time step `tstp`. Actually, it denotes ``G^{⌈}(τᵢ, tⱼ ≡ tstp)``

See also: [`CnMatV`](@ref), [`CnRetV`](@ref), [`CnLessV`](@ref).
"""
mutable struct CnRmixV{S} <: CnAbsVec{S}
    sign  :: I64 # Used to distinguish fermions and bosons
    ntau  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataL :: Ref{CnLmixV{S}}
end

#=
### *CnRmixV* : *Constructors*
=#

"""
    CnRmixV(sign::I64, lmix::CnLmixV{S})

Constructor. Note that the `rmix` component is not independent. We use
the `lmix` component to initialize it.
"""
function CnRmixV(sign::I64, lmix::CnLmixV{S}) where {S}
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
    CnRmixV(sign, ntau, ndim1, ndim2, dataL)
end

#=
### *CnRmixV* : *Indexing*
=#

"""
    Base.getindex(rmix::CnRmixV{S}, i::I64)

Visit the element stored in `CnRmixV` object.
"""
function Base.getindex(rmix::CnRmixV{S}, i::I64) where {S}
    # Sanity check
    @assert 1 ≤ i ≤ rmix.ntau

    # Return G^{⌈}(τᵢ, tⱼ ≡ tstp)
    (rmix.dataL[])[rmix.ntau - i + 1]' * (-rmix.sign)
end

#=
### *CnLessV* : *Struct*
=#

"""
    CnLessV{S}

Lesser component (``G^{<}``) of contour Green's function at given
time step `tstp`. Actually, it denotes ``G^{<}(tᵢ, tⱼ ≡ tstp)``.
"""
mutable struct CnLessV{S} <: CnAbsVec{S}
    tstp  :: I64
    ndim1 :: I64
    ndim2 :: I64
    data  :: VecArray{S}
end

#=
### *CnLessV* : *Constructors*
=#

"""
    CnLessV(tstp::I64, ndim1::I64, ndim2::I64, v::S)

Constructor. All the matrix elements are set to be `v`.
"""
function CnLessV(tstp::I64, ndim1::I64, ndim2::I64, v::S) where {S}
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
    CnLessV(tstp, ndim1, ndim2, data)
end

"""
    CnLessV(tstp::I64, ndim1::I64, ndim2::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLessV(tstp::I64, ndim1::I64, ndim2::I64)
    CnLessV(tstp, ndim1, ndim2, CZERO)
end

"""
    CnLessV(tstp::I64, ndim1::I64)

Constructor. All the matrix elements are set to be `CZERO`.
"""
function CnLessV(tstp::I64, ndim1::I64)
    CnLessV(tstp, ndim1, ndim1, CZERO)
end

"""
    CnLessV(tstp::I64, x::Element{S})

Constructor. The matrix is initialized by `x`.
"""
function CnLessV(tstp::I64, x::Element{S}) where {S}
    # Sanity check
    @assert tstp ≥ 1

    ndim1, ndim2 = size(x)
    data = VecArray{S}(undef, tstp)
    for i = 1:tstp
        data[i] = copy(x)
    end

    # Call the default constructor
    CnLessV(tstp, ndim1, ndim2, data)
end

#=
### *CnLessV* : *Properties*
=#

"""
    getdims(less::CnLessV{S})

Return the dimensional parameters of contour function.

See also: [`CnLessV`](@ref).
"""
function getdims(less::CnLessV{S}) where {S}
    return (less.ndim1, less.ndim2)
end

"""
    getsize(less::CnLessV{S})

Return the size of contour function.

See also: [`CnLessV`](@ref).
"""
function getsize(less::CnLessV{S}) where {S}
    return less.tstp
end

"""
    equaldims(less::CnLessV{S})

Return whether the dimensional parameters are equal.

See also: [`CnLessV`](@ref).
"""
function equaldims(less::CnLessV{S}) where {S}
    return less.ndim1 == less.ndim2
end

"""
    iscompatible(less1::CnLessV{S}, less2::CnLessV{S})

Judge whether two `CnLessV` objects are compatible.
"""
function iscompatible(less1::CnLessV{S}, less2::CnLessV{S}) where {S}
    getsize(less1) == getsize(less2) &&
    getdims(less1) == getdims(less2)
end

"""
    iscompatible(less1::CnLessV{S}, less2::CnLessM{S})

Judge whether the `CnLessV` and `CnLessM` objects are compatible.
"""
function iscompatible(less1::CnLessV{S}, less2::CnLessM{S}) where {S}
    getsize(less1) ≤ getsize(less2) &&
    getdims(less1) == getdims(less2)
end

"""
    iscompatible(less1::CnLessM{S}, less2::CnLessV{S})

Judge whether the `CnLessV` and `CnLessM` objects are compatible.
"""
iscompatible(less1::CnLessM{S}, less2::CnLessV{S}) where {S} = iscompatible(less2, less1)

"""
    iscompatible(C::Cn, less::CnLessV{S})

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `CnLessV{S}` object).
"""
function iscompatible(C::Cn, less::CnLessV{S}) where {S}
    C.ntime ≥ getsize(less) &&
    getdims(C) == getdims(less)
end

"""
    iscompatible(less::CnLessV{S}, C::Cn)

Judge whether `C` (which is a `Cn` object) is compatible with `less`
(which is a `CnLessV{S}` object).
"""
iscompatible(less::CnLessV{S}, C::Cn) where {S} = iscompatible(C, less)

"""
    distance(less1::CnLessV{S}, less2::CnLessV{S})

Calculate distance between two `CnLessV` objects.
"""
function distance(less1::CnLessV{S}, less2::CnLessV{S}) where {S}
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
    distance(less1::CnLessV{S}, less2::CnLessM{S}, tstp::I64)

Calculate distance between a `CnLessV` object and a `CnLessM` object at
given time step `tstp`.
"""
function distance(less1::CnLessV{S}, less2::CnLessM{S}, tstp::I64) where {S}
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
    distance(less1::CnLessM{S}, less2::CnLessV{S}, tstp::I64)

Calculate distance between a `CnLessV` object and a `CnLessM` object at
given time step `tstp`.
"""
distance(less1::CnLessM{S}, less2::CnLessV{S}, tstp::I64) where {S} = distance(less2, less1, tstp)

#=
### *CnLessV* : *Indexing*
=#

"""
    Base.getindex(less::CnLessV{S}, i::I64)

Visit the element stored in `CnLessV` object.
"""
function Base.getindex(less::CnLessV{S}, i::I64) where {S}
    # Sanity check
    @assert 1 ≤ i ≤ less.tstp

    # Return G^{<}(tᵢ, tⱼ ≡ tstp)
    less.data[i]
end

"""
    Base.getindex(less::CnLessV{S}, tstp::I64, j::I64)

Visit the element stored in `CnLessV` object.
"""
function Base.getindex(less::CnLessV{S}, tstp::I64, j::I64) where {S}
    # Sanity check
    @assert tstp == less.tstp
    @assert 1 ≤ j ≤ less.tstp

    # Return G^{<}(tᵢ ≡ tstp, tⱼ)
    -(less.data[i])'
end

"""
    Base.setindex!(less::CnLessV{S}, x::Element{S}, i::I64)

Setup the element in `CnLessV` object.
"""
function Base.setindex!(less::CnLessV{S}, x::Element{S}, i::I64) where {S}
    # Sanity check
    @assert size(x) == getdims(less)
    @assert 1 ≤ i ≤ less.tstp

    # G^{<}(tᵢ, tⱼ ≡ tstp) = x
    less.data[i] = copy(x)
end

"""
    Base.setindex!(less::CnLessV{S}, v::S, i::I64)

Setup the element in `CnLessV` object.
"""
function Base.setindex!(less::CnLessV{S}, v::S, i::I64) where {S}
    # Sanity check
    @assert 1 ≤ i ≤ less.tstp

    # G^{<}(tᵢ, tⱼ ≡ tstp) .= v
    fill!(less.data[i], v)
end

#=
### *CnLessV* : *Operations*
=#

"""
    memset!(less::CnLessV{S}, x)

Reset all the matrix elements of `less` to `x`. `x` should be a
scalar number.
"""
function memset!(less::CnLessV{S}, x) where {S}
    cx = convert(S, x)
    for i=1:less.tstp
        fill!(less.data[i], cx)
    end
end

"""
    zeros!(less::CnLessV{S})

Reset all the matrix elements of `less` to `ZERO`.
"""
zeros!(less::CnLessV{S}) where {S} = memset!(less, zero(S))

"""
    memcpy!(src::CnLessV{S}, dst::CnLessV{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnLessV{S}, dst::CnLessV{S}) where {S}
    @assert iscompatible(src, dst)
    @. dst.data = copy(src.data)
end

"""
    memcpy!(src::CnLessM{S}, dst::CnLessV{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnLessM{S}, dst::CnLessV{S}) where {S}
    @assert iscompatible(src, dst)
    tstp = dst.tstp
    @. dst.data = copy(src.data[1:tstp,tstp])
end

"""
    memcpy!(src::CnLessV{S}, dst::CnLessM{S})

Copy all the matrix elements from `src` to `dst`.
"""
function memcpy!(src::CnLessV{S}, dst::CnLessM{S}) where {S}
    @assert iscompatible(src, dst)
    tstp = src.tstp
    @. dst.data[1:tstp,tstp] = copy(src.data)
end

"""
    incr!(less1::CnLessV{S}, less2::CnLessV{S}, alpha::S)

Add a `CnLessV` with given weight (`alpha`) to another `CnLessV`.
"""
function incr!(less1::CnLessV{S}, less2::CnLessV{S}, alpha::S) where {S}
    @assert iscompatible(less1, less2)
    tstp = less2.tstp
    for i = 1:tstp
        @. less1.data[i] = less1.data[i] + less2.data[i] * alpha
    end
end

"""
    incr!(less1::CnLessM{S}, less2::CnLessV{S}, alpha::S)

Add a `CnLessV` with given weight (`alpha`) to a `CnLessM`.
"""
function incr!(less1::CnLessM{S}, less2::CnLessV{S}, alpha::S) where {S}
    @assert iscompatible(less1, less2)
    tstp = less2.tstp
    for i = 1:tstp
        @. less1.data[i,tstp] = less1.data[i,tstp] + less2.data[i] * alpha
    end
end

"""
    incr!(less1::CnLessV{S}, less2::CnLessM{S}, alpha::S)

Add a `CnLessM` with given weight (`alpha`) to a `CnLessV`.
"""
function incr!(less1::CnLessV{S}, less2::CnLessM{S}, alpha::S) where {S}
    @assert iscompatible(less1, less2)
    tstp = less1.tstp
    for i = 1:tstp
        @. less1.data[i] = less1.data[i] + less2.data[i,tstp] * alpha
    end
end

"""
    smul!(less::CnLessV{S}, alpha::S)

Multiply a `CnLessV` with given weight (`alpha`).
"""
function smul!(less::CnLessV{S}, alpha::S) where {S}
    for i = 1:less.tstp
        @. less.data[i] = less.data[i] * alpha
    end
end

"""
    smul!(x::CnFunF{S}, less::CnLessV{S})

Left multiply a `CnLessV` with given weight (`x`).
"""
function smul!(x::CnFunF{S}, less::CnLessV{S}) where {S}
    for i = 1:less.tstp
        less.data[i] = x[i] * less.data[i]
    end
end

"""
    smul!(less::CnLessV{S}, x::Element{S})

Right multiply a `CnLessV` with given weight (`x`).
"""
function smul!(less::CnLessV{S}, x::Element{S}) where {S}
    for i = 1:less.tstp
        less.data[i] = less.data[i] * x
    end
end

#=
### *CnLessV* : *Traits*
=#

"""
    Base.:+(less1::CnLessV{S}, less2::CnLessV{S})

Operation `+` for two `CnLessV` objects.
"""
function Base.:+(less1::CnLessV{S}, less2::CnLessV{S}) where {S}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    CnLessV(less1.tstp, less1.ndim1, less1.ndim2, less1.data + less2.data)
end

"""
    Base.:-(less1::CnLessV{S}, less2::CnLessV{S})

Operation `-` for two `CnLessV` objects.
"""
function Base.:-(less1::CnLessV{S}, less2::CnLessV{S}) where {S}
    # Sanity check
    @assert getsize(less1) == getsize(less2)
    @assert getdims(less1) == getdims(less2)

    CnLessV(less1.tstp, less1.ndim1, less1.ndim2, less1.data - less2.data)
end

"""
    Base.:*(less::CnLessV{S}, x)

Operation `*` for a `CnLessV` object and a scalar value.
"""
function Base.:*(less::CnLessV{S}, x) where {S}
    cx = convert(S, x)
    CnLessV(less.tstp, less.ndim1, less.ndim2, less.data * cx)
end

"""
    Base.:*(x, less::CnLessV{S})

Operation `*` for a scalar value and a `CnLessV` object.
"""
Base.:*(x, less::CnLessV{S}) where {S} = Base.:*(less, x)

#=
### *CnGtrV* : *Struct*
=#

"""
    CnGtrV{S}

Greater component (``G^{>}``) of contour Green's function at given
time step `tstp`.

See also: [`CnRetV`](@ref), [`CnLmixV`](@ref), [`CnLessV`](@ref).
"""
mutable struct CnGtrV{S} <: CnAbsVec{S}
    tstp  :: I64
    ndim1 :: I64
    ndim2 :: I64
    dataL :: Ref{CnLessV{S}}
    dataR :: Ref{CnRetV{S}}
end

#=
### *CnGtrV* : *Constructors*
=#

"""
    CnGtrV(less::CnLessV{S}, ret::CnRetV{S})

Constructor. Note that the `gtr` component is not independent. We use
the `less` and `ret` components to initialize it.
"""
function CnGtrV(less::CnLessV{S}, ret::CnRetV{S}) where {S}
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
    CnGtrV(tstp, ndim1, ndim2, dataL, dataR)
end

#=
### *CnGtrV* : *Indexing*
=#

"""
    Base.getindex(gtr::CnGtrV{S}, i::I64)

Visit the element stored in `CnGtrV` object.
"""
function Base.getindex(gtr::CnGtrV{S}, i::I64) where {S}
    # Sanity check
    @assert 1 ≤ i ≤ gtr.tstp

    # Return G^{>}(tᵢ, tⱼ ≡ tstp)
    gtr.dataL[][i] + gtr.dataR[][i, gtr.tstp]
end

"""
    Base.getindex(gtr::CnGtrV{S}, tstp::I64, j::I64)

Visit the element stored in `CnGtrV` object.
"""
function Base.getindex(gtr::CnGtrV{S}, tstp::I64, j::I64) where {S}
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
### *CnFunV* : *Struct*
=#

"""
    CnFunV{S}

Standard contour-ordered Green's function at given time step `tstp`. It
includes four independent components, namely `mat`, `ret`, `lmix`, and
`less`. If `tstp = 0`, it denotes the equilibrium state (only the `mat`
component is valid). On the other hand, `tstp > 0` means nonequilibrium
state.
"""
mutable struct CnFunV{S} <: CnAbsFun{S}
    sign :: I64 # Used to distinguish fermions and bosons
    tstp :: I64
    mat  :: CnMatV{S}
    ret  :: CnRetV{S}
    lmix :: CnLmixV{S}
    less :: CnLessV{S}
end

#=
### *CnFunV* : *Constructors*
=#

"""
    CnFunV(C::Cn, tstp::I64, v::S, sign::I64 = FERMI)

Standard constructor. This function is initialized by `v`.
"""
function CnFunV(C::Cn, tstp::I64, v::S, sign::I64 = FERMI) where {S}
    # Sanity check
    @assert sign in (BOSE, FERMI)
    @assert C.ntime ≥ tstp ≥ 0

    # Create mat, ret, lmix, and less.
    mat = CnMatV(C.ntau, C.ndim1, C.ndim2, v)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        ret = CnRetV(tstp + 1, C.ndim1, C.ndim2, v)
    else
        ret = CnRetV(tstp, C.ndim1, C.ndim2, v)
    end
    #
    lmix = CnLmixV(C.ntau, C.ndim1, C.ndim2, v)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        less = CnLessV(tstp + 1, C.ndim1, C.ndim2, v)
    else
        less = CnLessV(tstp, C.ndim1, C.ndim2, v)
    end

    # Call the default constructor
    CnFunV(sign, tstp, mat, ret, lmix, less)
end

"""
    CnFunV(C::Cn, tstp::I64, sign::I64 = FERMI)

Constructor. Create a fermionic contour function with zero initial values.
"""
function CnFunV(C::Cn, tstp::I64, sign::I64 = FERMI)
    # Sanity check
    @assert sign in (BOSE, FERMI)
    @assert C.ntime ≥ tstp ≥ 0

    # Create mat, ret, lmix, and less.
    mat = CnMatV(C.ntau, C.ndim1, C.ndim2)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        ret = CnRetV(tstp + 1, C.ndim1, C.ndim2)
    else
        ret = CnRetV(tstp, C.ndim1, C.ndim2)
    end
    #
    lmix = CnLmixV(C.ntau, C.ndim1, C.ndim2)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        less = CnLessV(tstp + 1, C.ndim1, C.ndim2)
    else
        less = CnLessV(tstp, C.ndim1, C.ndim2)
    end

    # Call the default constructor
    CnFunV(sign, tstp, mat, ret, lmix, less)
end

"""
    CnFunV(tstp::I64, ntau::I64, ndim1::I64, ndim2::I64, sign::I64 = FERMI)

Constructor. Create a fermionic contour function with zero initial values.
"""
function CnFunV(tstp::I64, ntau::I64, ndim1::I64, ndim2::I64, sign::I64 = FERMI)
    # Sanity check
    @assert sign in (BOSE, FERMI)
    @assert tstp ≥ 0
    @assert ntau ≥ 2
    @assert ndim1 ≥ 1
    @assert ndim2 ≥ 1

    # Create mat, ret, lmix, and less.
    mat = CnMatV(ntau, ndim1, ndim2)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        ret = CnRetV(tstp + 1, ndim1, ndim2)
    else
        ret = CnRetV(tstp, ndim1, ndim2)
    end
    #
    lmix = CnLmixV(ntau, ndim1, ndim2)
    #
    if tstp == 0
        # Actually, at this time this component should not be accessed.
        less = CnLessV(tstp + 1, ndim1, ndim2)
    else
        less = CnLessV(tstp, ndim1, ndim2)
    end

    # Call the default constructor
    CnFunV(sign, tstp, mat, ret, lmix, less)
end

#=
### *CnFunV* : *Properties*
=#

"""
    getdims(cfv::CnFunV{S})

Return the dimensional parameters of contour Green's function.

See also: [`CnFunV`](@ref).
"""
function getdims(cfv::CnFunV{S}) where {S}
    return getdims(cfv.less)
end

"""
    getntau(cfv::CnFunV{S})

Return the `ntau` parameter of contour Green's function.
"""
function getntau(cfv::CnFunV{S}) where {S}
    return getsize(cfv.mat)
end

"""
    gettstp(cfv::CnFunV{S})

Return the `tstp` parameter of contour Green's function.
"""
function gettstp(cfv::CnFunV{S}) where {S}
    return cfv.tstp # getsize(cfv.less) is wrong when cfv.tstp = 0!
end

"""
    getsign(cfv::CnFunV{S})

Return the `sign` parameter of contour Green's function.
"""
function getsign(cfv::CnFunV{S}) where {S}
    return cfv.sign
end

"""
    equaldims(cfv::CnFunV{S})

Return whether the dimensional parameters are equal.

See also: [`CnFunV`](@ref).
"""
function equaldims(cfv::CnFunV{S}) where {S}
    return equaldims(cfv.less)
end

"""
    density(cfv::CnFunV{S}, tstp::I64)

Returns the density matrix at given time step `tstp`. If `tstp = 0`,
it denotes the equilibrium state. However, when `tstp > 0`, it means
the nonequilibrium state.

See also: [`CnMatV`](@ref), [`CnLessV`](@ref).
"""
function density(cfv::CnFunV{S}, tstp::I64) where {S}
    # Sanity check
    @assert tstp == gettstp(cfv)

    if tstp == 0
        return -cfv.mat[getntau(cfv)]
    else
        return cfv.less[tstp] * getsign(cfv) * CZI
    end
end

"""
    distance(cfv1::CnFunV{S}, cfv2::CnFunV{S}, tstp::I64)

Calculate distance between two `CnFunV` objects at given time step `tstp`.
"""
function distance(cfv1::CnFunV{S}, cfv2::CnFunV{S}, tstp::I64) where {S}
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
    distance(cfv1::CnFunV{S}, cfm2::CnFunM{S}, tstp::I64)

Calculate distance between a `CnFunV` object and a `CnFunM` object at
given time step `tstp`.
"""
function distance(cfv1::CnFunV{S}, cfm2::CnFunM{S}, tstp::I64) where {S}
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
    distance(cfm1::CnFunM{S}, cfv2::CnFunV{S}, tstp::I64)

Calculate distance between a `CnFunV` object and a `CnFunM` object at
given time step `tstp`.
"""
distance(cfm1::CnFunM{S}, cfv2::CnFunV{S}, tstp::I64) where {S} = distance(cfv2, cfm1, tstp)

#=
### *CnFunV* : *Indexing*
=#

"""
    Base.getindex(cfm::CnFunM{T}, tstp::I64)

Return contour Green's function at given time step `tstp`.

See also: [`CnFunM`](@ref), [`CnFunV`](@ref).
"""
function Base.getindex(cfm::CnFunM{T}, tstp::I64) where {T}
    # Sanity check
    @assert getntime(cfm) ≥ tstp ≥ 0

    # Get key parameters
    sign = getsign(cfm)
    ntau = getntau(cfm)
    ndim1, ndim2 = getdims(cfm)

    # Construct an empty `CnFunV` struct
    cfv = CnFunV(tstp, ntau, ndim1, ndim2, sign)

    # Extract data at time step `tstp` from `CnFunM` object, then copy
    # them to `CnFunV` object.
    memcpy!(cfm, cfv)

    # Return the desired struct
    return cfv
end

"""
    Base.setindex!(cfm::CnFunM{S}, cfv::CnFunV{S}, tstp::I64)

Setup contout Green's function at given time step `tstp`.

See also: [`CnFunM`](@ref), [`CnFunV`](@ref).
"""
function Base.setindex!(cfm::CnFunM{S}, cfv::CnFunV{S}, tstp::I64) where {S}
    # Sanity check
    @assert tstp == gettstp(cfv)
    @assert 0 ≤ tstp ≤ getntime(cfm)

    # Copy data from `CnFunV` object to `CnFunM` object
    memcpy!(cfv, cfm)
end

#=
### *CnFunV* : *Operations*
=#

"""
    memset!(cfv::CnFunV{S}, x)

Reset all the matrix elements of `cfv` to `x`. `x` should be a
scalar number.
"""
function memset!(cfv::CnFunV{S}, x) where {S}
    memset!(cfv.mat, x)
    memset!(cfv.ret, x)
    memset!(cfv.lmix, x)
    memset!(cfv.less, x)
end

"""
    memset!(cfv::CnFunV{S}, tstp::I64, x)

Reset all the matrix elements of `cfv` to `x`. `x` should be a
scalar number. If `tstp = 0`, only the `mat` component is updated.
On the other hand, if `tstp > 0`, the `ret`, `lmix`, and `less`
components will be updated.
"""
function memset!(cfv::CnFunV{S}, tstp::I64, x) where {S}
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
    zeros!(cfv::CnFunV{S})

Reset all the matrix elements of `cfv` to `ZERO`.
"""
zeros!(cfv::CnFunV{S}) where {S} = memset!(cfv, zero(S))

"""
    zeros!(cfv::CnFunV{S}, tstp::I64)

Reset all the matrix elements of `cfv` to `ZERO` at given time step `tstp`.
"""
zeros!(cfv::CnFunV{S}, tstp::I64) where {S} = memset!(cfv, tstp, zero(S))

"""
    memcpy!(src::CnFunV{S}, dst::CnFunV{S}, tstp::I64)

Extract data from a `CnFunV` object (at given time step `tstp`), then
copy them to another `CnFunV` object.

See also: [`CnFunV`](@ref).
"""
function memcpy!(src::CnFunV{S}, dst::CnFunV{S}, tstp::I64) where {S}
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
    memcpy!(cfm::CnFunM{S}, cfv::CnFunV{S}, tstp::I64)

Extract data from a `CnFunM` object (at given time step `tstp`), then
copy them to a `CnFunV` object.

See also: [`CnFunM`](@ref), [`CnFunV`](@ref).
"""
function memcpy!(cfm::CnFunM{S}, cfv::CnFunV{S}, tstp::I64) where {S}
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
    memcpy!(cfv::CnFunV{S}, cfm::CnFunM{S}, tstp::I64)

Extract data from a `CnFunV` object, then copy them to a `CnFunM` object
(at given time step `tstp`).

See also: [`CnFunM`](@ref), [`CnFunV`](@ref).
"""
function memcpy!(cfv::CnFunV{S}, cfm::CnFunM{S}, tstp::I64) where {S}
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
    incr!(cfv1::CnFunV{S}, cfv2::CnFunV{S}, tstp::I64, alpha)

Adds a `CnFunV` with given weight (`alpha`) to another `CnFunV` (at given
time step `tstp`).
"""
function incr!(cfv1::CnFunV{S}, cfv2::CnFunV{S}, tstp::I64, alpha) where {S}
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
    incr!(cfm::CnFunM{S}, cfv::CnFunV{S}, tstp::I64, alpha)

Adds a `CnFunV` with given weight (`alpha`) to a `CnFunM` (at given
time step `tstp`).
"""
function incr!(cfm::CnFunM{S}, cfv::CnFunV{S}, tstp::I64, alpha) where {S}
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
    incr!(cfv::CnFunV{S}, cfm::CnFunM{S}, tstp::I64, alpha)

Adds a `CnFunM` with given weight (`alpha`) to a `CnFunV` (at given
time step `tstp`).
"""
function incr!(cfv::CnFunV{S}, cfm::CnFunM{S}, tstp::I64, alpha) where {S}
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
    smul!(cfv::CnFunV{S}, tstp::I64, alpha)

Multiply a `CnFunV` with given weight (`alpha`) at given time
step `tstp`.
"""
function smul!(cfv::CnFunV{S}, tstp::I64, alpha) where {S}
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
    smul!(cff::CnFunF{S}, cfv::CnFunV{S}, tstp::I64)

Left multiply a `CnFunV` with given weight (`CnFunF`) at given time
step `tstp`.
"""
function smul!(cff::CnFunF{S}, cfv::CnFunV{S}, tstp::I64) where {S}
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
    smul!(cfv::CnFunV{S}, cff::CnFunF{S}, tstp::I64)

Right multiply a `CnFunV` with given weight (`CnFunF`) at given time
step `tstp`.
"""
function smul!(cfv::CnFunV{S}, cff::CnFunF{S}, tstp::I64) where {S}
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
### *CnFunV* : *I/O*
=#

"""
    read!(fname::AbstractString, cfv::CnFunV{S})

Read the contour Green's functions from given file.
"""
function read!(fname::AbstractString, cfv::CnFunV{S}) where {S}
end

"""
    write(fname::AbstractString, cfv::CnFunV{S})

Write the contour Green's functions to given file.
"""
function write(fname::AbstractString, cfv::CnFunV{S}) where {S}
end

#=
### *CnFunV* : *Traits*
=#
