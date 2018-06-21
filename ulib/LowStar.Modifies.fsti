module LowStar.Modifies

module HS = FStar.HyperStack
module HST = FStar.HyperStack.ST
module B = LowStar.Buffer

/// The modifies clause for regions, references and buffers.
/// ==========================================================
///
/// This module presents the modifies clause, a way to track the set
/// of memory locations modified by a stateful Low* (or even F*)
/// program. The basic principle of modifies clauses is that any
/// location that is disjoint from a set of memory locations modified
/// by an operation is preserved by that operation.
///
/// We start by specifying a monoid of sets of memory locations. From
/// a rough high-level view, ``loc`` is the type of sets of memory
/// locations, equipped with an identity element ``loc_none``,
/// representing the empty set, and an associative and commutative
/// operator, ``loc_union``, representing the union of two sets of
/// memory locations.
///
/// Moreover, ``loc_union`` is idempotent, which is useful to cut SMT
/// matching loops with ``modifies_trans`` and ``modifies_refl`` below.

val loc : Type0

val loc_none: loc

val loc_union
  (s1 s2: loc)
: GTot loc

val loc_union_idem
  (s: loc)
: Lemma
  (loc_union s s == s)
  [SMTPat (loc_union s s)]

val loc_union_comm
  (s1 s2: loc)
: Lemma
  (loc_union s1 s2 == loc_union s2 s1)
  [SMTPat (loc_union s1 s2)]

val loc_union_assoc
  (s1 s2 s3: loc)
: Lemma
  (loc_union s1 (loc_union s2 s3) == loc_union (loc_union s1 s2) s3)

let loc_union_idem_1
  (s1 s2: loc)
: Lemma
  (loc_union s1 (loc_union s1 s2) == loc_union s1 s2)
  [SMTPat (loc_union s1 (loc_union s1 s2) == loc_union s1 s2)]
= loc_union_assoc s1 s1 s2

let loc_union_idem_2
  (s1 s2: loc)
: Lemma
  (loc_union (loc_union s1 s2) s2 == loc_union s1 s2)
  [SMTPat (loc_union (loc_union s1 s2) s2)]
= loc_union_assoc s1 s2 s2

val loc_union_loc_none_l
  (s: loc)
: Lemma
  (loc_union loc_none s == s)
  [SMTPat (loc_union loc_none s)]

val loc_union_loc_none_r
  (s: loc)
: Lemma
  (loc_union s loc_none == s)
  [SMTPat (loc_union s loc_none)]


/// ``loc_buffer b`` is the set of memory locations associated to a buffer ``b``.

val loc_buffer
  (#t: Type)
  (b: B.buffer t)
: GTot loc

val loc_buffer_null
  (t: Type)
: Lemma
  (loc_buffer (B.null #t) == loc_none)
  [SMTPat (loc_buffer (B.null #t))]


/// ``loc_addresses r n`` is the set of memory locations associated to a
/// set of addresses ``n`` in a given region ``r``.

val loc_addresses
  (preserve_liveness: bool)
  (r: HS.rid)
  (n: Set.set nat)
: GTot loc


/// ``loc_regions r`` is the set of memory locations associated to a set
/// ``r`` of regions.

val loc_regions
  (preserve_liveness: bool)
  (r: Set.set HS.rid)
: GTot loc


/// ``loc_mreference b`` is the set of memory locations associated to a
/// reference ``b``, which is actually the set of memory locations
/// associated to the address of ``b``.

unfold
let loc_mreference
  (#a: Type)
  (#p: Preorder.preorder a)
  (b: HS.mreference a p)
: GTot loc
= loc_addresses true (HS.frameOf b) (Set.singleton (HS.as_addr b))

unfold
let loc_freed_mreference
  (#a: Type)
  (#p: Preorder.preorder a)
  (b: HS.mreference a p)
: GTot loc
= loc_addresses false (HS.frameOf b) (Set.singleton (HS.as_addr b))


/// ``loc_region_only r`` is the set of memory locations associated to a
/// region ``r`` but not any region ``r'`` that extends ``r`` (in the sense
/// of ``FStar.HyperStack.extends``.)

unfold
let loc_region_only
  (preserve_liveness: bool)
  (r: HS.rid)
: GTot loc
= loc_regions preserve_liveness (Set.singleton r)


/// ``loc_all_regions_from r`` is the set of all memory locations
/// associated to a region ``r`` and any region ``r'`` that transitively
/// extends ``r`` (in the sense of ``FStar.HyperStack.extends``,
/// e.g. nested stack frames.)

unfold
let loc_all_regions_from
  (preserve_liveness: bool)
  (r: HS.rid)
: GTot loc
= loc_regions preserve_liveness (HS.mod_set (Set.singleton r))


/// We equip the ``loc`` monoid of sets of memory locations with an
/// inclusion relation, ``loc_includes``, which is a preorder compatible
/// with ``loc_union``. Although we consider sets of memory locations,
/// we do not specify them using any F* set library such as
/// ``FStar.Set``, ``FStar.TSet`` or ``FStar.GSet``, because ``loc_includes``
/// encompasses more than just set-theoretic inclusion.

val loc_includes
  (s1 s2: loc)
: GTot Type0

val loc_includes_refl
  (s: loc)
: Lemma
  (loc_includes s s)
  [SMTPat (loc_includes s s)]

val loc_includes_trans
  (s1 s2 s3: loc)
: Lemma
  (requires (loc_includes s1 s2 /\ loc_includes s2 s3))
  (ensures (loc_includes s1 s3))

val loc_includes_union_r
  (s s1 s2: loc)
: Lemma
  (requires (loc_includes s s1 /\ loc_includes s s2))
  (ensures (loc_includes s (loc_union s1 s2)))
  [SMTPat (loc_includes s (loc_union s1 s2))]

val loc_includes_union_l
  (s1 s2 s: loc)
: Lemma
  (requires (loc_includes s1 s \/ loc_includes s2 s))
  (ensures (loc_includes (loc_union s1 s2) s))

val loc_includes_none
  (s: loc)
: Lemma
  (loc_includes s loc_none)
  [SMTPat (loc_includes s loc_none)]


/// If a buffer ``b1`` includes a buffer ``b2`` in the sense of the buffer
/// theory (see ``LowStar.Buffer.includes``), then so are their
/// corresponding sets of memory locations.

val loc_includes_buffer
  (#t: Type)
  (b1 b2: B.buffer t)
: Lemma
  (requires (b1 `B.includes` b2))
  (ensures (loc_includes (loc_buffer b1) (loc_buffer b2)))
  [SMTPatOr [
    [SMTPat (B.includes b1 b2)];
    [SMTPat (loc_includes(loc_buffer b1) (loc_buffer b2))]
  ]]

val loc_includes_gsub_buffer_r
  (l: loc)
  (#t: Type)
  (b: B.buffer t)
  (i: UInt32.t)
  (len: UInt32.t)
: Lemma
  (requires (UInt32.v i + UInt32.v len <= (B.length b) /\ loc_includes l (loc_buffer b)))
  (ensures (UInt32.v i + UInt32.v len <= (B.length b) /\ loc_includes l (loc_buffer (B.gsub b i len))))
  [SMTPat (loc_includes l (loc_buffer (B.gsub b i len)))]

val loc_includes_gsub_buffer_l
  (#t: Type)
  (b: B.buffer t)
  (i1: UInt32.t)
  (len1: UInt32.t)
  (i2: UInt32.t)
  (len2: UInt32.t)
: Lemma
  (requires (UInt32.v i1 + UInt32.v len1 <= (B.length b) /\ UInt32.v i1 <= UInt32.v i2 /\ UInt32.v i2 + UInt32.v len2 <= UInt32.v i1 + UInt32.v len1))
  (ensures (UInt32.v i1 + UInt32.v len1 <= (B.length b) /\ UInt32.v i1 <= UInt32.v i2 /\ UInt32.v i2 + UInt32.v len2 <= UInt32.v i1 + UInt32.v len1 /\ loc_includes (loc_buffer (B.gsub b i1 len1)) (loc_buffer (B.gsub b i2 len2))))
  [SMTPat (loc_includes (loc_buffer (B.gsub b i1 len1)) (loc_buffer (B.gsub b i2 len2)))]


/// Given a buffer ``b``, if its address is in a set ``s`` of addresses in
/// the region of ``b``, then the set of memory locations corresponding
/// to ``b`` is included in the set of memory locations corresponding to
/// the addresses in ``s`` in region ``r``.
///
/// In particular, the set of memory locations corresponding to a
/// buffer is included in the set of memory locations corresponding to
/// its region and address.

val loc_includes_addresses_buffer
  (#t: Type)
  (preserve_liveness: bool)
  (r: HS.rid)
  (s: Set.set nat)
  (p: B.buffer t)
: Lemma
  (requires (B.frameOf p == r /\ Set.mem (B.as_addr p) s))
  (ensures (loc_includes (loc_addresses preserve_liveness r s) (loc_buffer p)))
  [SMTPat (loc_includes (loc_addresses preserve_liveness r s) (loc_buffer p))]


/// The set of memory locations corresponding to a buffer is included
/// in the set of memory locations corresponding to its region.

val loc_includes_region_buffer
  (#t: Type)
  (preserve_liveness: bool)
  (s: Set.set HS.rid)
  (b: B.buffer t)
: Lemma
  (requires (Set.mem (B.frameOf b) s))
  (ensures (loc_includes (loc_regions preserve_liveness s) (loc_buffer b)))
  [SMTPat (loc_includes (loc_regions preserve_liveness s) (loc_buffer b))]


/// If a region ``r`` is in a set of regions ``s``, then the set of memory
/// locations corresponding to a set of addresses ``a`` in ``r`` is
/// included in the set of memory locations corresponding to the
/// regions in ``s``.
///
/// In particular, the the set of memory locations corresponding to a
/// set of addresses ``a`` in a given region ``r`` is included in the set
/// of memory locations corresponding to region ``r``.

val loc_includes_region_addresses
  (preserve_liveness1: bool)
  (preserve_liveness2: bool)
  (s: Set.set HS.rid)
  (r: HS.rid)
  (a: Set.set nat)
: Lemma
  (requires (Set.mem r s))
  (ensures (loc_includes (loc_regions preserve_liveness1 s) (loc_addresses preserve_liveness2 r a)))
  [SMTPat (loc_includes (loc_regions preserve_liveness1 s) (loc_addresses preserve_liveness2 r a))]

/// If a set of region identifiers ``s1`` includes a set of region
/// identifiers ``s2``, then so are their corresponding sets of memory
/// locations.

val loc_includes_region_region
  (preserve_liveness1: bool)
  (preserve_liveness2: bool)
  (s1 s2: Set.set HS.rid)
: Lemma
  (requires ((preserve_liveness1 ==> preserve_liveness2) /\ Set.subset s2 s1))
  (ensures (loc_includes (loc_regions preserve_liveness1 s1) (loc_regions preserve_liveness2 s2)))
  [SMTPat (loc_includes (loc_regions preserve_liveness1 s1) (loc_regions preserve_liveness2 s2))]

/// The following lemma can act as a cut when reasoning with sets of
/// memory locations corresponding to sets of regions.

val loc_includes_region_union_l
  (preserve_liveness: bool)
  (l: loc)
  (s1 s2: Set.set HS.rid)
: Lemma
  (requires (loc_includes l (loc_regions preserve_liveness (Set.intersect s2 (Set.complement s1)))))
  (ensures (loc_includes (loc_union (loc_regions preserve_liveness s1) l) (loc_regions preserve_liveness s2)))
  [SMTPat (loc_includes (loc_union (loc_regions preserve_liveness s1) l) (loc_regions preserve_liveness s2))]


/// If a set of addresses ``s1`` includes a set of addresses ``s2``,
/// then so are their corresponding memory locations
val loc_includes_addresses_addresses
  (preserve_liveness1 preserve_liveness2: bool)
  (r: HS.rid)
  (s1 s2: Set.set nat)
: Lemma
  (requires ((preserve_liveness1 ==> preserve_liveness2) /\ Set.subset s2 s1))
  (ensures (loc_includes (loc_addresses preserve_liveness1 r s1) (loc_addresses preserve_liveness2 r s2)))

/// Patterns with loc_includes, union on the left

let loc_includes_union_l_buffer
  (s1 s2: loc)
  (#t: Type)
  (b: B.buffer t)
: Lemma
  (requires (loc_includes s1 (loc_buffer b) \/ loc_includes s2 (loc_buffer b)))
  (ensures (loc_includes (loc_union s1 s2) (loc_buffer b)))
  [SMTPat (loc_includes (loc_union s1 s2) (loc_buffer b))]
= loc_includes_union_l s1 s2 (loc_buffer b)

let loc_includes_union_l_addresses
  (s1 s2: loc)
  (prf: bool)
  (r: HS.rid)
  (a: Set.set nat)
: Lemma
  (requires (loc_includes s1 (loc_addresses prf r a) \/ loc_includes s2 (loc_addresses prf r a)))
  (ensures (loc_includes (loc_union s1 s2) (loc_addresses prf r a)))
  [SMTPat (loc_includes (loc_union s1 s2) (loc_addresses prf r a))]
= loc_includes_union_l s1 s2 (loc_addresses prf r a)

let loc_includes_union_l_regions
  (s1 s2: loc)
  (prf: bool)
  (r: Set.set HS.rid)
: Lemma
  (requires (loc_includes s1 (loc_regions prf r) \/ loc_includes s2 (loc_regions prf r)))
  (ensures (loc_includes (loc_union s1 s2) (loc_regions prf r)))
  [SMTPat (loc_includes (loc_union s1 s2) (loc_regions prf r))]
= loc_includes_union_l s1 s2 (loc_regions prf r)

/// Since inclusion encompasses more than just set-theoretic
/// inclusion, we also need to specify disjointness accordingly, as a
/// symmetric relation compatible with union.

val loc_disjoint
  (s1 s2: loc)
: GTot Type0

val loc_disjoint_sym
  (s1 s2: loc)
: Lemma
  (requires (loc_disjoint s1 s2))
  (ensures (loc_disjoint s2 s1))

let loc_disjoint_sym'
  (s1 s2: loc)
: Lemma
  (loc_disjoint s1 s2 <==> loc_disjoint s2 s1)
  [SMTPat (loc_disjoint s1 s2)]
= Classical.move_requires (loc_disjoint_sym s1) s2;
  Classical.move_requires (loc_disjoint_sym s2) s1

val loc_disjoint_none_r
  (s: loc)
: Lemma
  (ensures (loc_disjoint s loc_none))
  [SMTPat (loc_disjoint s loc_none)]

val loc_disjoint_union_r
  (s s1 s2: loc)
: Lemma
  (requires (loc_disjoint s s1 /\ loc_disjoint s s2))
  (ensures (loc_disjoint s (loc_union s1 s2)))

/// If two sets of memory locations are disjoint, then so are any two
/// included sets of memory locations.

val loc_disjoint_includes
  (p1 p2 p1' p2' : loc)
: Lemma
  (requires (loc_includes p1 p1' /\ loc_includes p2 p2' /\ loc_disjoint p1 p2))
  (ensures (loc_disjoint p1' p2'))

/// If two buffers are disjoint in the sense of the theory of buffers
/// (see ``LowStar.Buffer.disjoint``), then so are their corresponding
/// sets of memory locations.

val loc_disjoint_buffer
  (#t1 #t2: Type)
  (b1: B.buffer t1)
  (b2: B.buffer t2)
: Lemma
  (requires (B.disjoint b1 b2))
  (ensures (loc_disjoint (loc_buffer b1) (loc_buffer b2)))
  [SMTPatOr [
    [SMTPat (B.disjoint b1 b2)];
    [SMTPat (loc_disjoint (loc_buffer b1) (loc_buffer b2))];
  ]]

val loc_disjoint_gsub_buffer
  (#t: Type)
  (b: B.buffer t)
  (i1: UInt32.t)
  (len1: UInt32.t)
  (i2: UInt32.t)
  (len2: UInt32.t)
: Lemma
  (requires (
    UInt32.v i1 + UInt32.v len1 <= (B.length b) /\
    UInt32.v i2 + UInt32.v len2 <= (B.length b) /\ (
    UInt32.v i1 + UInt32.v len1 <= UInt32.v i2 \/
    UInt32.v i2 + UInt32.v len2 <= UInt32.v i1
  )))
  (ensures (
    UInt32.v i1 + UInt32.v len1 <= (B.length b) /\
    UInt32.v i2 + UInt32.v len2 <= (B.length b) /\
    loc_disjoint (loc_buffer (B.gsub b i1 len1)) (loc_buffer (B.gsub b i2 len2))
  ))
  [SMTPat (loc_disjoint (loc_buffer (B.gsub b i1 len1)) (loc_buffer (B.gsub b i2 len2)))]


/// If two sets of addresses correspond to different regions or are
/// disjoint, then their corresponding sets of memory locations are
/// disjoint.

val loc_disjoint_addresses
  (preserve_liveness1 preserve_liveness2: bool)
  (r1 r2: HS.rid)
  (n1 n2: Set.set nat)
: Lemma
  (requires (r1 <> r2 \/ Set.subset (Set.intersect n1 n2) Set.empty))
  (ensures (loc_disjoint (loc_addresses preserve_liveness1 r1 n1) (loc_addresses preserve_liveness2 r2 n2)))
  [SMTPat (loc_disjoint (loc_addresses preserve_liveness1 r1 n1) (loc_addresses preserve_liveness2 r2 n2))]

/// If the region of a buffer ``p`` is not ``r``, or its address is not in
/// the set ``n`` of addresses, then their corresponding sets of memory
/// locations are disjoint.

val loc_disjoint_buffer_addresses
  (#t: Type)
  (p: B.buffer t)
  (preserve_liveness: bool)
  (r: HS.rid)
  (n: Set.set nat)
: Lemma
  (requires (r <> B.frameOf p \/ (~ (Set.mem (B.as_addr p) n))))
  (ensures (loc_disjoint (loc_buffer p) (loc_addresses preserve_liveness r n)))
  [SMTPat (loc_disjoint (loc_buffer p) (loc_addresses preserve_liveness r n))]

val loc_disjoint_buffer_regions
  (#t: Type)
  (p: B.buffer t)
  (preserve_liveness: bool)
  (r: Set.set HS.rid)
: Lemma
  (requires (~ (B.frameOf p `Set.mem` r)))
  (ensures (loc_disjoint (loc_buffer p) (loc_regions preserve_liveness r)))
  [SMTPat (loc_disjoint (loc_buffer p) (loc_regions preserve_liveness r))]

/// If two sets of region identifiers are disjoint, then so are their
/// corresponding sets of memory locations.

val loc_disjoint_regions
  (preserve_liveness1: bool)
  (preserve_liveness2: bool)
  (rs1 rs2: Set.set HS.rid)
: Lemma
  (requires (Set.subset (Set.intersect rs1 rs2) Set.empty))
  (ensures (loc_disjoint (loc_regions preserve_liveness1 rs1) (loc_regions preserve_liveness2 rs2)))
  [SMTPat (loc_disjoint (loc_regions preserve_liveness1 rs1) (loc_regions preserve_liveness2 rs2))]


/// The modifies clauses proper.
///
/// Let ``s`` be a set of memory locations, and ``h1`` and ``h2`` be two
/// memory states. Then, ``s`` is modified from ``h1`` to ``h2`` only if,
/// any memory location disjoint from ``s`` is preserved from ``h1`` into
/// ``h2``. Elimination lemmas illustrating this principle follow.

val modifies
  (s: loc)
  (h1 h2: HS.mem)
: GTot Type0

/// If a region ``r`` is disjoint from a set ``s`` of memory locations
/// which is modified, then its liveness is preserved.

val modifies_live_region
  (s: loc)
  (h1 h2: HS.mem)
  (r: HS.rid)
: Lemma
  (requires (modifies s h1 h2 /\ loc_disjoint s (loc_region_only false r) /\ HS.live_region h1 r))
  (ensures (HS.live_region h2 r))

/// If a reference ``b`` is disjoint from a set ``p`` of memory locations
/// which is modified, then its liveness and contents are preserved.

val modifies_mreference_elim
  (#t: Type)
  (#pre: Preorder.preorder t)
  (b: HS.mreference t pre)
  (p: loc)
  (h h': HS.mem)
: Lemma
  (requires (
    loc_disjoint (loc_mreference b) p /\
    HS.contains h b /\
    modifies p h h'
  ))
  (ensures (
    HS.contains h' b /\
    HS.sel h b == HS.sel h' b
  ))

/// If a buffer ``b`` is disjoint from a set ``p`` of
/// memory locations which is modified, then its liveness and contents
/// are preserved.

val modifies_buffer_elim
  (#t1: Type)
  (b: B.buffer t1)
  (p: loc)
  (h h': HS.mem)
: Lemma
  (requires (
    loc_disjoint (loc_buffer b) p /\
    B.live h b /\
    modifies p h h'
  ))
  (ensures (
    B.live h' b /\ (
    B.as_seq h b == B.as_seq h' b
  )))

/// If the memory state does not change, then any memory location is
/// modified (and, in particular, the empty set, ``loc_none``.)

val modifies_refl
  (s: loc)
  (h: HS.mem)
: Lemma
  (modifies s h h)

/// If a set ``s2`` of memory locations is modified, then so is any set
/// ``s1`` that includes ``s2``. In other words, it is always possible to
/// weaken a modifies clause by widening its set of memory locations.

val modifies_loc_includes
  (s1: loc)
  (h h': HS.mem)
  (s2: loc)
: Lemma
  (requires (modifies s2 h h' /\ loc_includes s1 s2))
  (ensures (modifies s1 h h'))

/// Some memory locations are tagged as liveness-insensitive: the
/// liveness preservation of a memory location only depends on its
/// disjointness from the liveness-sensitive memory locations of a
/// modifies clause.

val address_liveness_insensitive_locs: loc

val region_liveness_insensitive_locs: loc

val address_liveness_insensitive_buffer (#t: Type) (b: B.buffer t) : Lemma
  (address_liveness_insensitive_locs `loc_includes` (loc_buffer b))
  [SMTPat (address_liveness_insensitive_locs `loc_includes` (loc_buffer b))]

val address_liveness_insensitive_addresses (r: HS.rid) (a: Set.set nat) : Lemma
  (address_liveness_insensitive_locs `loc_includes` (loc_addresses true r a))
  [SMTPat (address_liveness_insensitive_locs `loc_includes` (loc_addresses true r a))]

val region_liveness_insensitive_buffer (#t: Type) (b: B.buffer t) : Lemma
  (region_liveness_insensitive_locs `loc_includes` (loc_buffer b))
  [SMTPat (region_liveness_insensitive_locs `loc_includes` (loc_buffer b))]

val region_liveness_insensitive_addresses (preserve_liveness: bool) (r: HS.rid) (a: Set.set nat) : Lemma
  (region_liveness_insensitive_locs `loc_includes` (loc_addresses preserve_liveness r a))
  [SMTPat (region_liveness_insensitive_locs `loc_includes` (loc_addresses preserve_liveness r a))]

val region_liveness_insensitive_regions (rs: Set.set HS.rid) : Lemma
  (region_liveness_insensitive_locs `loc_includes` (loc_regions true rs))
  [SMTPat (region_liveness_insensitive_locs `loc_includes` (loc_regions true rs))]

val region_liveness_insensitive_address_liveness_insensitive:
  squash (region_liveness_insensitive_locs `loc_includes` address_liveness_insensitive_locs)

val modifies_liveness_insensitive_mreference
  (l1 l2 : loc)
  (h h' : HS.mem)
  (#t: Type)
  (#pre: Preorder.preorder t)
  (x: HS.mreference t pre)
: Lemma
  (requires (modifies (loc_union l1 l2) h h' /\ loc_disjoint l1 (loc_mreference x) /\ address_liveness_insensitive_locs `loc_includes` l2 /\ h `HS.contains` x))
  (ensures (h' `HS.contains` x))
  (* TODO: pattern *)

val modifies_liveness_insensitive_buffer
  (l1 l2 : loc)
  (h h' : HS.mem)
  (#t: Type)
  (x: B.buffer t)
: Lemma
  (requires (modifies (loc_union l1 l2) h h' /\ loc_disjoint l1 (loc_buffer x) /\ address_liveness_insensitive_locs `loc_includes` l2 /\ B.live h x))
  (ensures (B.live h' x))
  (* TODO: pattern *)

let modifies_liveness_insensitive_mreference_weak
  (l : loc)
  (h h' : HS.mem)
  (#t: Type)
  (#pre: Preorder.preorder t)
  (x: HS.mreference t pre)
: Lemma
  (requires (modifies l h h' /\ address_liveness_insensitive_locs `loc_includes` l /\ h `HS.contains` x))
  (ensures (h' `HS.contains` x))
= modifies_liveness_insensitive_mreference loc_none l h h' x

let modifies_liveness_insensitive_buffer_weak
  (l : loc)
  (h h' : HS.mem)
  (#t: Type)
  (x: B.buffer t)
: Lemma
  (requires (modifies l h h' /\ address_liveness_insensitive_locs `loc_includes` l /\ B.live h x))
  (ensures (B.live h' x))
= modifies_liveness_insensitive_buffer loc_none l h h' x

val modifies_liveness_insensitive_region
  (l1 l2 : loc)
  (h h' : HS.mem)
  (x: HS.rid)
: Lemma
  (requires (modifies (loc_union l1 l2) h h' /\ loc_disjoint l1 (loc_region_only false x) /\ region_liveness_insensitive_locs `loc_includes` l2 /\ HS.live_region h x))
  (ensures (HS.live_region h' x))
  (* TODO: pattern *)

val modifies_liveness_insensitive_region_mreference
  (l1 l2 : loc)
  (h h' : HS.mem)
  (#t: Type)
  (#pre: Preorder.preorder t)
  (x: HS.mreference t pre)
: Lemma
  (requires (modifies (loc_union l1 l2) h h' /\ loc_disjoint l1 (loc_mreference x) /\ region_liveness_insensitive_locs `loc_includes` l2 /\ HS.live_region h (HS.frameOf x)))
  (ensures (HS.live_region h' (HS.frameOf x)))
  (* TODO: pattern *)

val modifies_liveness_insensitive_region_buffer
  (l1 l2 : loc)
  (h h' : HS.mem)
  (#t: Type)
  (x: B.buffer t)
: Lemma
  (requires (modifies (loc_union l1 l2) h h' /\ loc_disjoint l1 (loc_buffer x) /\ region_liveness_insensitive_locs `loc_includes` l2 /\ HS.live_region h (B.frameOf x)))
  (ensures (HS.live_region h' (B.frameOf x)))
  (* TODO: pattern *)

let modifies_liveness_insensitive_region_weak
  (l2 : loc)
  (h h' : HS.mem)
  (x: HS.rid)
: Lemma
  (requires (modifies l2 h h' /\ region_liveness_insensitive_locs `loc_includes` l2 /\ HS.live_region h x))
  (ensures (HS.live_region h' x))
= modifies_liveness_insensitive_region loc_none l2 h h' x

let modifies_liveness_insensitive_region_mreference_weak
  (l2 : loc)
  (h h' : HS.mem)
  (#t: Type)
  (#pre: Preorder.preorder t)
  (x: HS.mreference t pre)
: Lemma
  (requires (modifies l2 h h' /\ region_liveness_insensitive_locs `loc_includes` l2 /\ HS.live_region h (HS.frameOf x)))
  (ensures (HS.live_region h' (HS.frameOf x)))
= modifies_liveness_insensitive_region_mreference loc_none l2 h h' x

let modifies_liveness_insensitive_region_buffer_weak
  (l2 : loc)
  (h h' : HS.mem)
  (#t: Type)
  (x: B.buffer t)
: Lemma
  (requires (modifies l2 h h' /\ region_liveness_insensitive_locs `loc_includes` l2 /\ HS.live_region h (B.frameOf x)))
  (ensures (HS.live_region h' (B.frameOf x)))
= modifies_liveness_insensitive_region_buffer loc_none l2 h h' x


/// Modifies clauses are transitive. This lemma is the most general
/// one.

val modifies_trans
  (s12: loc)
  (h1 h2: HS.mem)
  (s23: loc)
  (h3: HS.mem)
: Lemma
  (requires (modifies s12 h1 h2 /\ modifies s23 h2 h3))
  (ensures (modifies (loc_union s12 s23) h1 h3))

/// Regions that are not live can be removed from sets of memory
/// locations that are modified.

val modifies_only_live_regions
  (rs: Set.set HS.rid)
  (l: loc)
  (h h' : HS.mem)
: Lemma
  (requires (
    modifies (loc_union (loc_regions false rs) l) h h' /\
    (forall r . Set.mem r rs ==> (~ (HS.live_region h r)))
  ))
  (ensures (modifies l h h'))

/// As a consequence, fresh regions can be removed from modifies
/// clauses.

val no_upd_fresh_region: r:HS.rid -> l:loc -> h0:HS.mem -> h1:HS.mem -> Lemma
  (requires (HS.fresh_region r h0 h1 /\ modifies (loc_union (loc_all_regions_from false r) l) h0 h1))
  (ensures  (modifies l h0 h1))

val fresh_frame_modifies (h0 h1: HS.mem) : Lemma
  (requires (HS.fresh_frame h0 h1))
  (ensures (modifies loc_none h0 h1))

val popped_modifies (h0 h1: HS.mem) : Lemma
  (requires (HS.popped h0 h1))
  (ensures (modifies (loc_region_only false (HS.get_tip h0)) h0 h1))

/// Stack discipline: any stack frame (and all its transitively
/// extending regions) that is pushed, modified and popped can be
/// removed from a modifies clause.

val modifies_fresh_frame_popped
  (h0 h1: HS.mem)
  (s: loc)
  (h2 h3: HS.mem)
: Lemma
  (requires (
    HS.fresh_frame h0 h1 /\
    modifies (loc_union (loc_all_regions_from false (HS.get_tip h1)) s) h1 h2 /\
    (HS.get_tip h2) == (HS.get_tip h1) /\
    HS.popped h2 h3
  ))
  (ensures (
    modifies s h0 h3 /\
    (HS.get_tip h3) == HS.get_tip h0
  ))

/// Compatibility lemmas to rescue modifies clauses specified in the
/// standard F* HyperStack library.

val modifies_loc_regions_intro
  (rs: Set.set HS.rid)
  (h1 h2: HS.mem)
: Lemma
  (requires (HS.modifies rs h1 h2))
  (ensures (modifies (loc_regions true rs) h1 h2))

val modifies_loc_addresses_intro
  (r: HS.rid)
  (a: Set.set nat)
  (l: loc)
  (h1 h2: HS.mem)
: Lemma
  (requires (
    HS.live_region h2 r /\
    modifies (loc_union (loc_region_only false r) l) h1 h2 /\
    HS.modifies_ref r a h1 h2
  ))
  (ensures (modifies (loc_union (loc_addresses true r a) l) h1 h2))

/// Modifies clauses for allocating a reference: nothing is
/// modified. (In particular, a modifies clause does not track
/// memory locations that are created.)

val modifies_ralloc_post
  (#a: Type)
  (#rel: Preorder.preorder a)
  (i: HS.rid)
  (init: a)
  (h: HS.mem)
  (x: HST.mreference a rel { HST.is_eternal_region (HS.frameOf x) } )
  (h' : HS.mem)
: Lemma
  (requires (HST.ralloc_post i init h x h'))
  (ensures (modifies loc_none h h'))

val modifies_salloc_post
  (#a: Type)
  (#rel: Preorder.preorder a)
  (init: a)
  (h: HS.mem)
  (x: HST.mreference a rel { HS.is_stack_region (HS.frameOf x) } )
  (h' : HS.mem)
: Lemma
  (requires (HST.salloc_post init h x h'))
  (ensures (modifies loc_none h h'))

/// Modifies clause for freeing a reference: the address is modified.

val modifies_free
  (#a: Type)
  (#rel: Preorder.preorder a)
  (r: HS.mreference a rel { HS.is_mm r } )
  (m: HS.mem { m `HS.contains` r } )
: Lemma
  (modifies (loc_freed_mreference r) m (HS.free r m))

/// Another compatibility lemma

val modifies_none_modifies
  (h1 h2: HS.mem)
: Lemma
  (requires (HST.modifies_none h1 h2))
  (ensures (modifies loc_none h1 h2))

/// Main lemmas to integrate non-compositional modifies clauses
/// specified in ``LowStar.Buffer`` for elementary operations.
///
/// Case ``modifies_0``: allocation.

val modifies_0_modifies
  (h1 h2: HS.mem)
: Lemma
  (requires (B.modifies_0 h1 h2))
  (ensures (modifies loc_none h1 h2))
  [SMTPat (B.modifies_0 h1 h2)]

/// Case ``modifies_1``: update.

val modifies_1_modifies
  (#a: Type)
  (b: B.buffer a)
  (h1 h2: HS.mem)
: Lemma
  (requires (B.modifies_1 b h1 h2))
  (ensures (modifies (loc_buffer b) h1 h2))
  [SMTPat (B.modifies_1 b h1 h2)]

/// Case ``modifies_addr_of``: free. 

val modifies_addr_of_modifies
  (#a: Type)
  (b: B.buffer a)
  (h1 h2: HS.mem)
: Lemma
  (requires (B.modifies_addr_of b h1 h2))
  (ensures (modifies (loc_addresses false (B.frameOf b) (Set.singleton (B.as_addr b))) h1 h2))
  [SMTPat (B.modifies_addr_of b h1 h2)]


/// Any live reference is disjoint from a buffer which has not been allocated yet.

val mreference_live_buffer_unused_in_disjoint
  (#t1: Type)
  (#pre: Preorder.preorder t1)
  (#t2: Type)
  (h: HS.mem)
  (b1: HS.mreference t1 pre)
  (b2: B.buffer t2)
: Lemma
  (requires (HS.contains h b1 /\ B.unused_in b2 h))
  (ensures (loc_disjoint (loc_freed_mreference b1) (loc_buffer b2)))
  [SMTPat (HS.contains h b1); SMTPat (B.unused_in b2 h)]

/// Any live buffer is disjoint from a reference which has not been
/// allocated yet.

val buffer_live_mreference_unused_in_disjoint
  (#t1: Type)
  (#t2: Type)
  (#pre: Preorder.preorder t2)
  (h: HS.mem)
  (b1: B.buffer t1)
  (b2: HS.mreference t2 pre)
: Lemma
  (requires (B.live h b1 /\ HS.unused_in b2 h))
  (ensures (loc_disjoint (loc_buffer b1) (loc_freed_mreference b2)))
  [SMTPat (B.live h b1); SMTPat (HS.unused_in b2 h)]

///  A memory ``h`` does not contain address ``a`` in region ``r``, denoted
///  ``does_not_contain_addr h (r, a)``, only if, either region ``r`` is
///  not live, or address ``a`` is unused in region ``r``.

(* BEGIN TODO: move to FStar.Monotonic.HyperStack *)

val does_not_contain_addr
  (h: HS.mem)
  (ra: HS.rid * nat)
: GTot Type0

val not_live_region_does_not_contain_addr
  (h: HS.mem)
  (ra: HS.rid * nat)
: Lemma
  (requires (~ (HS.live_region h (fst ra))))
  (ensures (h `does_not_contain_addr` ra))

val unused_in_does_not_contain_addr
  (h: HS.mem)
  (#a: Type)
  (#rel: Preorder.preorder a)
  (r: HS.mreference a rel)
: Lemma
  (requires (r `HS.unused_in` h))
  (ensures (h `does_not_contain_addr` (HS.frameOf r, HS.as_addr r)))

val addr_unused_in_does_not_contain_addr
  (h: HS.mem)
  (ra: HS.rid * nat)
: Lemma
  (requires (HS.live_region h (fst ra) ==> snd ra `Heap.addr_unused_in` (Map.sel (HS.get_hmap h) (fst ra))))
  (ensures (h `does_not_contain_addr` ra))

val free_does_not_contain_addr
  (#a: Type0)
  (#rel: Preorder.preorder a)
  (r: HS.mreference a rel)
  (m: HS.mem)
  (x: HS.rid * nat)
: Lemma
  (requires (
    HS.is_mm r /\
    m `HS.contains` r /\
    fst x == HS.frameOf r /\
    snd x == HS.as_addr r
  ))
  (ensures (
    HS.free r m `does_not_contain_addr` x
  ))
  [SMTPat (HS.free r m `does_not_contain_addr` x)]

val does_not_contain_addr_elim
  (#a: Type0)
  (#rel: Preorder.preorder a)
  (r: HS.mreference a rel)
  (m: HS.mem)
  (x: HS.rid * nat)
: Lemma
  (requires (
    m `does_not_contain_addr` x /\
    HS.frameOf r == fst x /\
    HS.as_addr r == snd x
  ))
  (ensures (~ (m `HS.contains` r)))

(** END TODO *)

/// Addresses that have not been allocated yet can be removed from
/// modifies clauses.

val modifies_only_live_addresses
  (r: HS.rid)
  (a: Set.set nat)
  (l: loc)
  (h h' : HS.mem)
: Lemma
  (requires (
    modifies (loc_union (loc_addresses false r a) l) h h' /\
    (forall x . Set.mem x a ==> h `does_not_contain_addr` (r, x))
  ))
  (ensures (modifies l h h'))


(* Generic way to ensure that a buffer just allocated is disjoint from
   any other object, however the latter's liveness is defined. *)

val loc_not_unused_in (h: HS.mem) : GTot loc

val loc_unused_in (h: HS.mem) : GTot loc

val live_loc_not_unused_in (#t: Type) (b: B.buffer t) (h: HS.mem) : Lemma
  (requires (B.live h b))
  (ensures (loc_not_unused_in h `loc_includes` loc_buffer b))

val unused_in_loc_unused_in (#t: Type) (b: B.buffer t) (h: HS.mem) : Lemma
  (requires (B.unused_in b h))
  (ensures (loc_unused_in h `loc_includes` loc_buffer b))

val modifies_address_liveness_insensitive_unused_in
  (h h' : HS.mem)
: Lemma
  (requires (modifies (address_liveness_insensitive_locs) h h'))
  (ensures (loc_not_unused_in h' `loc_includes` loc_not_unused_in h /\ loc_unused_in h `loc_includes` loc_unused_in h'))

val mreference_live_loc_not_unused_in
  (#t: Type)
  (#pre: Preorder.preorder t)
  (h: HS.mem)
  (r: HS.mreference t pre)
: Lemma
  (requires (h `HS.contains` r))
  (ensures (loc_not_unused_in h `loc_includes` loc_freed_mreference r /\ loc_not_unused_in h `loc_includes` loc_mreference r))

val mreference_unused_in_loc_unused_in
  (#t: Type)
  (#pre: Preorder.preorder t)
  (h: HS.mem)
  (r: HS.mreference t pre)
: Lemma
  (requires (r `HS.unused_in` h))
  (ensures (loc_unused_in h `loc_includes` loc_freed_mreference r /\ loc_unused_in h `loc_includes` loc_mreference r))


/// Type class instantiation for compositionality with other kinds of memory locations than regions, references or buffers (just in case).
/// No usage pattern has been found yet.

module MG = FStar.ModifiesGen

val cloc_cls: MG.cls B.abuffer

val cloc_of_loc (l: loc) : Tot (MG.loc cloc_cls)

val loc_of_cloc (l: MG.loc cloc_cls) : Tot loc

val loc_of_cloc_of_loc (l: loc) : Lemma
  (loc_of_cloc (cloc_of_loc l) == l)
  [SMTPat (loc_of_cloc (cloc_of_loc l))]

val cloc_of_loc_of_cloc (l: MG.loc cloc_cls) : Lemma
  (cloc_of_loc (loc_of_cloc l) == l)
  [SMTPat (cloc_of_loc (loc_of_cloc l))]

val cloc_of_loc_none: unit -> Lemma (cloc_of_loc loc_none == MG.loc_none)

val cloc_of_loc_union (l1 l2: loc) : Lemma
  (cloc_of_loc (loc_union l1 l2) == MG.loc_union (cloc_of_loc l1) (cloc_of_loc l2))

val cloc_of_loc_addresses
  (preserve_liveness: bool)
  (r: HS.rid)
  (n: Set.set nat)
: Lemma
  (cloc_of_loc (loc_addresses preserve_liveness r n) == MG.loc_addresses preserve_liveness r n)

val cloc_of_loc_regions
  (preserve_liveness: bool)
  (r: Set.set HS.rid)
: Lemma
  (cloc_of_loc (loc_regions preserve_liveness r) == MG.loc_regions preserve_liveness r)

val loc_includes_to_cloc (l1 l2: loc) : Lemma
  (loc_includes l1 l2 <==> MG.loc_includes (cloc_of_loc l1) (cloc_of_loc l2))

val loc_disjoint_to_cloc (l1 l2: loc) : Lemma
  (loc_disjoint l1 l2 <==> MG.loc_disjoint (cloc_of_loc l1) (cloc_of_loc l2))

val modifies_to_cloc (l: loc) (h1 h2: HS.mem) : Lemma
  (modifies l h1 h2 <==> MG.modifies (cloc_of_loc l) h1 h2)
