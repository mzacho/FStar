module DM4F

#set-options "--print_universes"

(* Simulating state effect in DM4F, hopefully doable by a tactic. *)

type wp0 (st:Type u#0) (a:Type u#ua) : Type u#(max 1 ua) =
  st -> (a & st -> Type0) -> Type0

let st_monotonic #st #a (w : wp0 st a) : Type0 =
  //forall s0 p1 p2. (forall r. p1 r ==> p2 r) ==> w s0 p1 ==> w s0 p2
  // ^ this version seems to be less SMT-friendly
  forall s0 p1 p2. (forall x s1. p1 (x, s1) ==> p2 (x, s1)) ==> w s0 p1 ==> w s0 p2

type wp st a = w:(wp0 st a)//{st_monotonic w}

type repr (a:Type u#ua) (st:Type0) (wp : wp u#ua st a) : Type u#ua =
  s0:st -> PURE (a & st) (wp s0)

type return (a:Type) (x:a) (st:Type0) : repr a st (fun s0 p -> p (x, s0)) =
  fun s0 -> (x, s0)

type bind (a:Type) (b:Type) (st:Type0)
  (wp_c : wp st a)
  (wp_f : a -> wp st b)
  (c : repr a st wp_c)
  (f : (x:a -> repr b st (wp_f x)))
: repr b st  (fun s0 p -> wp_c s0 (fun (y, s1) -> wp_f y s1 p))
= fun s0 -> assume (st_monotonic wp_c);
         assume (forall x. st_monotonic (wp_f x));
         let (y, s1) = c s0 in
         f y s1

let if_then_else
  (a:Type)
  (st:Type0)
  (wpf wpg : wp st a)
  (f : repr a st wpf)
  (g : repr a st wpg)
  (b : bool)
  : Type
  = repr a st (fun s0 p -> (b ==> wpf s0 p) /\ ((~b) ==> wpg s0 p))

let stronger
  (#a:Type) (#st:Type0)
  (w1 w2 : wp st a)
  : Type0
  = forall s0 p. w1 s0 p ==> w2 s0 p

let subcomp
  (a:Type)
  (st:Type0)
  (wpf wpg : wp st a)
  (f : repr a st wpf)
  : Pure (repr a st wpg)
         (requires (stronger wpg wpf))
         (ensures (fun _ -> True))
  = f

total
reifiable
reflectable
layered_effect {
  ST : a:Type -> st:Type0 -> wp st a -> Effect
  with
  repr = repr;
  return = return;
  bind = bind;
  if_then_else = if_then_else;
  subcomp = subcomp
}
