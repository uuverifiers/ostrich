module Uint : sig
  type t = int
  val dflt_size : Z.t
  val less : t -> t -> bool
  val less_eq : t -> t -> bool
  val set_bit : t -> Z.t -> bool -> t
  val shiftl : t -> Z.t -> t
  val shiftr : t -> Z.t -> t
  val shiftr_signed : t -> Z.t -> t
  val test_bit : t -> Z.t -> bool
  val int_mask : int
  val int32_mask : int32
  val int64_mask : int64
end = struct

type t = int

let dflt_size = Z.of_int Sys.int_size;;

(* negative numbers have their highest bit set, 
   so they are greater than positive ones *)
let less x y =
  if x<0 then
    y<0 && x<y
  else y < 0 || x < y;;

let less_eq x y =
  if x < 0 then
    y < 0 &&  x <= y
  else y < 0 || x <= y;;

let set_bit x n b =
  let mask = 1 lsl (Z.to_int n)
  in if b then x lor mask
     else x land (lnot mask);;

let shiftl x n = x lsl (Z.to_int n);;

let shiftr x n = x lsr (Z.to_int n);;

let shiftr_signed x n = x asr (Z.to_int n);;

let test_bit x n = x land (1 lsl (Z.to_int n)) <> 0;;

let int_mask =
  if Sys.int_size < 32 then lnot 0 else 0xFFFFFFFF;;

let int32_mask = 
  if Sys.int_size < 32 then Int32.pred (Int32.shift_left Int32.one Sys.int_size)
  else Int32.of_string "0xFFFFFFFF";;

let int64_mask = 
  if Sys.int_size < 64 then Int64.pred (Int64.shift_left Int64.one Sys.int_size)
  else Int64.of_string "0xFFFFFFFFFFFFFFFF";;

end;; (*struct Uint*)

module Uint32 : sig
  val less : int32 -> int32 -> bool
  val less_eq : int32 -> int32 -> bool
  val set_bit : int32 -> Z.t -> bool -> int32
  val shiftl : int32 -> Z.t -> int32
  val shiftr : int32 -> Z.t -> int32
  val shiftr_signed : int32 -> Z.t -> int32
  val test_bit : int32 -> Z.t -> bool
end = struct

(* negative numbers have their highest bit set, 
   so they are greater than positive ones *)
let less x y =
  if Int32.compare x Int32.zero < 0 then
    Int32.compare y Int32.zero < 0 && Int32.compare x y < 0
  else Int32.compare y Int32.zero < 0 || Int32.compare x y < 0;;

let less_eq x y =
  if Int32.compare x Int32.zero < 0 then
    Int32.compare y Int32.zero < 0 && Int32.compare x y <= 0
  else Int32.compare y Int32.zero < 0 || Int32.compare x y <= 0;;

let set_bit x n b =
  let mask = Int32.shift_left Int32.one (Z.to_int n)
  in if b then Int32.logor x mask
     else Int32.logand x (Int32.lognot mask);;

let shiftl x n = Int32.shift_left x (Z.to_int n);;

let shiftr x n = Int32.shift_right_logical x (Z.to_int n);;

let shiftr_signed x n = Int32.shift_right x (Z.to_int n);;

let test_bit x n =
  Int32.compare 
    (Int32.logand x (Int32.shift_left Int32.one (Z.to_int n)))
    Int32.zero
  <> 0;;

end;; (*struct Uint32*)

module Bits_Integer : sig
  val shiftl : Z.t -> Z.t -> Z.t
  val shiftr : Z.t -> Z.t -> Z.t
  val test_bit : Z.t -> Z.t -> bool
end = struct

(* We do not need an explicit range checks here,
   because Big_int.int_of_big_int raises Failure 
   if the argument does not fit into an int. *)
let shiftl x n = Z.shift_left x (Z.to_int n);;

let shiftr x n = Z.shift_right x (Z.to_int n);;

let test_bit x n =  Z.testbit x (Z.to_int n);;

end;; (*struct Bits_Integer*)

module Automata_lib : sig
  type 'a enum
  type 'a linorder
  type 'a equal
  type nat
  type 'a nFA_states
  type ('b, 'a) rbt
  type 'a set
  val prod_encode : nat * nat -> nat
  val rs_nfa_concate :
    'a nFA_states * 'a linorder -> 'b linorder ->
      ('a, unit) rbt *
        (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
          (('a, unit) rbt * ('a, unit) rbt)) ->
        ('a, unit) rbt *
          (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
            (('a, unit) rbt * ('a, unit) rbt)) ->
          ('a, unit) rbt *
            (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
              (('a, unit) rbt * ('a, unit) rbt))
  val rs_nfa_destruct :
    'a nFA_states * 'a linorder -> 'b linorder ->
      ('a, unit) rbt *
        (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
          (('a, unit) rbt * ('a, unit) rbt)) ->
        'a list * (('a * (('b * 'b) * 'a)) list * ('a list * 'a list))
  val rs_nfa_bool_comb :
    'a nFA_states * 'a linorder -> 'b linorder ->
      (bool -> bool -> bool) ->
        ('a, unit) rbt *
          (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
            (('a, unit) rbt * ('a, unit) rbt)) ->
          ('a, unit) rbt *
            (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
              (('a, unit) rbt * ('a, unit) rbt)) ->
            ('a, unit) rbt *
              (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
                (('a, unit) rbt * ('a, unit) rbt))
  val rs_indegree :
    'a equal * 'a linorder ->
      ('a, unit) rbt -> ('a, (('a * 'a), unit) rbt) rbt -> bool
  val rs_nfa_concate_rename :
    'a nFA_states * 'a linorder -> 'b linorder ->
      ('a -> 'a * 'a) ->
        ('a -> 'a * 'a) ->
          ('a, unit) rbt *
            (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
              (('a, unit) rbt * ('a, unit) rbt)) ->
            ('a, unit) rbt *
              (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
                (('a, unit) rbt * ('a, unit) rbt)) ->
              ('a, unit) rbt *
                (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
                  (('a, unit) rbt * ('a, unit) rbt))
  val rs_S_to_list : 'a linorder -> ('a, unit) rbt -> 'a list
  val rs_rc_to_list :
    'a enum * 'a linorder ->
      ('a, (('a * 'a), unit) rbt) rbt -> ('a * ('a * 'a) set) list
  val rs_rm_to_list :
    'a linorder -> 'b nFA_states * 'b linorder -> 'c linorder ->
      ('a, (('b, unit) rbt *
             (('b, (('c * 'c), ('b, unit) rbt) rbt) rbt *
               (('b, unit) rbt * ('b, unit) rbt))))
        rbt ->
        ('a * (('b, unit) rbt *
                (('b, (('c * 'c), ('b, unit) rbt) rbt) rbt *
                  (('b, unit) rbt * ('b, unit) rbt)))) list
  val rs_nfa_construct_interval :
    'a nFA_states * 'a linorder -> 'b linorder ->
      'a list * (('a * (('b * 'b) * 'a)) list * ('a list * 'a list)) ->
        ('a, unit) rbt *
          (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
            (('a, unit) rbt * ('a, unit) rbt))
  val rs_nfa_construct_reachable :
    'a nFA_states * 'a linorder -> 'b linorder ->
      ('a, unit) rbt *
        (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
          (('a, unit) rbt * ('a, unit) rbt)) ->
        ('a, unit) rbt *
          (('a, (('b * 'b), ('a, unit) rbt) rbt) rbt *
            (('a, unit) rbt * ('a, unit) rbt))
  val rs_gen_S_from_list : 'a linorder -> 'a list -> ('a, unit) rbt
  val rs_forward_analysis :
    'a nFA_states * 'a linorder -> 'b linorder -> 'c linorder ->
      'a -> 'a -> ('b, unit) rbt ->
                    ('b, (('b * 'b), unit) rbt) rbt ->
                      ('b, (('a, unit) rbt *
                             (('a, (('c * 'c), ('a, unit) rbt) rbt) rbt *
                               (('a, unit) rbt * ('a, unit) rbt))))
                        rbt ->
                        ('b, unit) rbt *
                          (('b, (('a, unit) rbt *
                                  (('a, (('c * 'c), ('a, unit) rbt) rbt) rbt *
                                    (('a, unit) rbt * ('a, unit) rbt))))
                             rbt *
                            ('b, unit) rbt)
  val rs_gen_rc_from_list :
    'a linorder -> ('a * ('a * 'a) list) list -> ('a, (('a * 'a), unit) rbt) rbt
  val rs_gen_rm_from_list :
    'a linorder -> 'b nFA_states * 'b linorder -> 'c linorder ->
      ('a * (('b, unit) rbt *
              (('b, (('c * 'c), ('b, unit) rbt) rbt) rbt *
                (('b, unit) rbt * ('b, unit) rbt)))) list ->
        ('a, (('b, unit) rbt *
               (('b, (('c * 'c), ('b, unit) rbt) rbt) rbt *
                 (('b, unit) rbt * ('b, unit) rbt))))
          rbt
end = struct

type 'a finite = unit;;

type 'a enum =
  {finite_enum : 'a finite; enum : 'a list; enum_all : ('a -> bool) -> bool;
    enum_ex : ('a -> bool) -> bool};;
let enum _A = _A.enum;;
let enum_all _A = _A.enum_all;;
let enum_ex _A = _A.enum_ex;;

let rec enum_all_prod _A _B
  p = enum_all _A (fun x -> enum_all _B (fun y -> p (x, y)));;

let rec enum_ex_prod _A _B
  p = enum_ex _A (fun x -> enum_ex _B (fun y -> p (x, y)));;

let rec map f x1 = match f, x1 with f, [] -> []
              | f, x21 :: x22 -> f x21 :: map f x22;;

let rec product x0 uu = match x0, uu with [], uu -> []
                  | x :: xs, ys -> map (fun a -> (x, a)) ys @ product xs ys;;

let rec enum_proda _A _B = product (enum _A) (enum _B);;

let rec finite_prod _A _B = (() : ('a * 'b) finite);;

let rec enum_prod _A _B =
  ({finite_enum = (finite_prod _A.finite_enum _B.finite_enum);
     enum = enum_proda _A _B; enum_all = enum_all_prod _A _B;
     enum_ex = enum_ex_prod _A _B}
    : ('a * 'b) enum);;

type 'a ord = {less_eq : 'a -> 'a -> bool; less : 'a -> 'a -> bool};;
let less_eq _A = _A.less_eq;;
let less _A = _A.less;;

let rec less_eq_prod _A _B
  (x1, y1) (x2, y2) = less _A x1 x2 || less_eq _A x1 x2 && less_eq _B y1 y2;;

let rec less_prod _A _B
  (x1, y1) (x2, y2) = less _A x1 x2 || less_eq _A x1 x2 && less _B y1 y2;;

let rec ord_prod _A _B =
  ({less_eq = less_eq_prod _A _B; less = less_prod _A _B} : ('a * 'b) ord);;

type 'a preorder = {ord_preorder : 'a ord};;

type 'a order = {preorder_order : 'a preorder};;

let rec preorder_prod _A _B =
  ({ord_preorder = (ord_prod _A.ord_preorder _B.ord_preorder)} :
    ('a * 'b) preorder);;

let rec order_prod _A _B =
  ({preorder_order = (preorder_prod _A.preorder_order _B.preorder_order)} :
    ('a * 'b) order);;

type 'a linorder = {order_linorder : 'a order};;

let rec linorder_prod _A _B =
  ({order_linorder = (order_prod _A.order_linorder _B.order_linorder)} :
    ('a * 'b) linorder);;

let ord_integer = ({less_eq = Z.leq; less = Z.lt} : Z.t ord);;

type 'a equal = {equal : 'a -> 'a -> bool};;
let equal _A = _A.equal;;

type nat = Nat of Z.t;;

type 'a nFA_states = {states_enumerate : nat -> 'a};;
let states_enumerate _A = _A.states_enumerate;;

type num = One | Bit0 of num | Bit1 of num;;

type color = R | B;;

type ('a, 'b) rbta = Empty |
  Branch of color * ('a, 'b) rbta * 'a * 'b * ('a, 'b) rbta;;

type ('b, 'a) rbt = RBT of ('b, 'a) rbta;;

type 'a set = Set of 'a list | Coset of 'a list;;

let rec id x = (fun xa -> xa) x;;

let rec eq _A a b = equal _A a b;;

let rec is_none = function Some x -> false
                  | None -> true;;

let rec filter
  p x1 = match p, x1 with p, [] -> []
    | p, x :: xs -> (if p x then x :: filter p xs else filter p xs);;

let rec collect _A p = Set (filter p (enum _A));;

let rec dom _A m = collect _A (fun a -> not (is_none (m a)));;

let rec integer_of_nat (Nat x) = x;;

let rec plus_nat m n = Nat (Z.add (integer_of_nat m) (integer_of_nat n));;

let one_nat : nat = Nat (Z.of_int 1);;

let rec suc n = plus_nat n one_nat;;

let rec comp f g = (fun x -> f (g x));;

let rec empty _A = RBT Empty;;

let rec foldl f a x2 = match f, a, x2 with f, a, [] -> a
                | f, a, x :: xs -> foldl f (f a x) xs;;

let rec balance
  x0 s t x3 = match x0, s, t, x3 with
    Branch (R, a, w, x, b), s, t, Branch (R, c, y, z, d) ->
      Branch (R, Branch (B, a, w, x, b), s, t, Branch (B, c, y, z, d))
    | Branch (R, Branch (R, a, w, x, b), s, t, c), y, z, Empty ->
        Branch (R, Branch (B, a, w, x, b), s, t, Branch (B, c, y, z, Empty))
    | Branch (R, Branch (R, a, w, x, b), s, t, c), y, z,
        Branch (B, va, vb, vc, vd)
        -> Branch
             (R, Branch (B, a, w, x, b), s, t,
               Branch (B, c, y, z, Branch (B, va, vb, vc, vd)))
    | Branch (R, Empty, w, x, Branch (R, b, s, t, c)), y, z, Empty ->
        Branch (R, Branch (B, Empty, w, x, b), s, t, Branch (B, c, y, z, Empty))
    | Branch (R, Branch (B, va, vb, vc, vd), w, x, Branch (R, b, s, t, c)), y,
        z, Empty
        -> Branch
             (R, Branch (B, Branch (B, va, vb, vc, vd), w, x, b), s, t,
               Branch (B, c, y, z, Empty))
    | Branch (R, Empty, w, x, Branch (R, b, s, t, c)), y, z,
        Branch (B, va, vb, vc, vd)
        -> Branch
             (R, Branch (B, Empty, w, x, b), s, t,
               Branch (B, c, y, z, Branch (B, va, vb, vc, vd)))
    | Branch (R, Branch (B, ve, vf, vg, vh), w, x, Branch (R, b, s, t, c)), y,
        z, Branch (B, va, vb, vc, vd)
        -> Branch
             (R, Branch (B, Branch (B, ve, vf, vg, vh), w, x, b), s, t,
               Branch (B, c, y, z, Branch (B, va, vb, vc, vd)))
    | Empty, w, x, Branch (R, b, s, t, Branch (R, c, y, z, d)) ->
        Branch (R, Branch (B, Empty, w, x, b), s, t, Branch (B, c, y, z, d))
    | Branch (B, va, vb, vc, vd), w, x,
        Branch (R, b, s, t, Branch (R, c, y, z, d))
        -> Branch
             (R, Branch (B, Branch (B, va, vb, vc, vd), w, x, b), s, t,
               Branch (B, c, y, z, d))
    | Empty, w, x, Branch (R, Branch (R, b, s, t, c), y, z, Empty) ->
        Branch (R, Branch (B, Empty, w, x, b), s, t, Branch (B, c, y, z, Empty))
    | Empty, w, x,
        Branch (R, Branch (R, b, s, t, c), y, z, Branch (B, va, vb, vc, vd))
        -> Branch
             (R, Branch (B, Empty, w, x, b), s, t,
               Branch (B, c, y, z, Branch (B, va, vb, vc, vd)))
    | Branch (B, va, vb, vc, vd), w, x,
        Branch (R, Branch (R, b, s, t, c), y, z, Empty)
        -> Branch
             (R, Branch (B, Branch (B, va, vb, vc, vd), w, x, b), s, t,
               Branch (B, c, y, z, Empty))
    | Branch (B, va, vb, vc, vd), w, x,
        Branch (R, Branch (R, b, s, t, c), y, z, Branch (B, ve, vf, vg, vh))
        -> Branch
             (R, Branch (B, Branch (B, va, vb, vc, vd), w, x, b), s, t,
               Branch (B, c, y, z, Branch (B, ve, vf, vg, vh)))
    | Empty, s, t, Empty -> Branch (B, Empty, s, t, Empty)
    | Empty, s, t, Branch (B, va, vb, vc, vd) ->
        Branch (B, Empty, s, t, Branch (B, va, vb, vc, vd))
    | Empty, s, t, Branch (v, Empty, vb, vc, Empty) ->
        Branch (B, Empty, s, t, Branch (v, Empty, vb, vc, Empty))
    | Empty, s, t, Branch (v, Branch (B, ve, vf, vg, vh), vb, vc, Empty) ->
        Branch
          (B, Empty, s, t,
            Branch (v, Branch (B, ve, vf, vg, vh), vb, vc, Empty))
    | Empty, s, t, Branch (v, Empty, vb, vc, Branch (B, vf, vg, vh, vi)) ->
        Branch
          (B, Empty, s, t,
            Branch (v, Empty, vb, vc, Branch (B, vf, vg, vh, vi)))
    | Empty, s, t,
        Branch
          (v, Branch (B, ve, vj, vk, vl), vb, vc, Branch (B, vf, vg, vh, vi))
        -> Branch
             (B, Empty, s, t,
               Branch
                 (v, Branch (B, ve, vj, vk, vl), vb, vc,
                   Branch (B, vf, vg, vh, vi)))
    | Branch (B, va, vb, vc, vd), s, t, Empty ->
        Branch (B, Branch (B, va, vb, vc, vd), s, t, Empty)
    | Branch (B, va, vb, vc, vd), s, t, Branch (B, ve, vf, vg, vh) ->
        Branch (B, Branch (B, va, vb, vc, vd), s, t, Branch (B, ve, vf, vg, vh))
    | Branch (B, va, vb, vc, vd), s, t, Branch (v, Empty, vf, vg, Empty) ->
        Branch
          (B, Branch (B, va, vb, vc, vd), s, t,
            Branch (v, Empty, vf, vg, Empty))
    | Branch (B, va, vb, vc, vd), s, t,
        Branch (v, Branch (B, vi, vj, vk, vl), vf, vg, Empty)
        -> Branch
             (B, Branch (B, va, vb, vc, vd), s, t,
               Branch (v, Branch (B, vi, vj, vk, vl), vf, vg, Empty))
    | Branch (B, va, vb, vc, vd), s, t,
        Branch (v, Empty, vf, vg, Branch (B, vj, vk, vl, vm))
        -> Branch
             (B, Branch (B, va, vb, vc, vd), s, t,
               Branch (v, Empty, vf, vg, Branch (B, vj, vk, vl, vm)))
    | Branch (B, va, vb, vc, vd), s, t,
        Branch
          (v, Branch (B, vi, vn, vo, vp), vf, vg, Branch (B, vj, vk, vl, vm))
        -> Branch
             (B, Branch (B, va, vb, vc, vd), s, t,
               Branch
                 (v, Branch (B, vi, vn, vo, vp), vf, vg,
                   Branch (B, vj, vk, vl, vm)))
    | Branch (v, Empty, vb, vc, Empty), s, t, Empty ->
        Branch (B, Branch (v, Empty, vb, vc, Empty), s, t, Empty)
    | Branch (v, Empty, vb, vc, Branch (B, ve, vf, vg, vh)), s, t, Empty ->
        Branch
          (B, Branch (v, Empty, vb, vc, Branch (B, ve, vf, vg, vh)), s, t,
            Empty)
    | Branch (v, Branch (B, vf, vg, vh, vi), vb, vc, Empty), s, t, Empty ->
        Branch
          (B, Branch (v, Branch (B, vf, vg, vh, vi), vb, vc, Empty), s, t,
            Empty)
    | Branch
        (v, Branch (B, vf, vg, vh, vi), vb, vc, Branch (B, ve, vj, vk, vl)),
        s, t, Empty
        -> Branch
             (B, Branch
                   (v, Branch (B, vf, vg, vh, vi), vb, vc,
                     Branch (B, ve, vj, vk, vl)),
               s, t, Empty)
    | Branch (v, Empty, vf, vg, Empty), s, t, Branch (B, va, vb, vc, vd) ->
        Branch
          (B, Branch (v, Empty, vf, vg, Empty), s, t,
            Branch (B, va, vb, vc, vd))
    | Branch (v, Empty, vf, vg, Branch (B, vi, vj, vk, vl)), s, t,
        Branch (B, va, vb, vc, vd)
        -> Branch
             (B, Branch (v, Empty, vf, vg, Branch (B, vi, vj, vk, vl)), s, t,
               Branch (B, va, vb, vc, vd))
    | Branch (v, Branch (B, vj, vk, vl, vm), vf, vg, Empty), s, t,
        Branch (B, va, vb, vc, vd)
        -> Branch
             (B, Branch (v, Branch (B, vj, vk, vl, vm), vf, vg, Empty), s, t,
               Branch (B, va, vb, vc, vd))
    | Branch
        (v, Branch (B, vj, vk, vl, vm), vf, vg, Branch (B, vi, vn, vo, vp)),
        s, t, Branch (B, va, vb, vc, vd)
        -> Branch
             (B, Branch
                   (v, Branch (B, vj, vk, vl, vm), vf, vg,
                     Branch (B, vi, vn, vo, vp)),
               s, t, Branch (B, va, vb, vc, vd));;

let rec paint c x1 = match c, x1 with c, Empty -> Empty
                | c, Branch (uu, l, k, v, r) -> Branch (c, l, k, v, r);;

let rec balance_right
  a k x xa3 = match a, k, x, xa3 with
    a, k, x, Branch (R, b, s, y, c) ->
      Branch (R, a, k, x, Branch (B, b, s, y, c))
    | Branch (B, a, k, x, b), s, y, Empty ->
        balance (Branch (R, a, k, x, b)) s y Empty
    | Branch (B, a, k, x, b), s, y, Branch (B, va, vb, vc, vd) ->
        balance (Branch (R, a, k, x, b)) s y (Branch (B, va, vb, vc, vd))
    | Branch (R, a, k, x, Branch (B, b, s, y, c)), t, z, Empty ->
        Branch (R, balance (paint R a) k x b, s, y, Branch (B, c, t, z, Empty))
    | Branch (R, a, k, x, Branch (B, b, s, y, c)), t, z,
        Branch (B, va, vb, vc, vd)
        -> Branch
             (R, balance (paint R a) k x b, s, y,
               Branch (B, c, t, z, Branch (B, va, vb, vc, vd)))
    | Empty, k, x, Empty -> Empty
    | Branch (R, va, vb, vc, Empty), k, x, Empty -> Empty
    | Branch (R, va, vb, vc, Branch (R, ve, vf, vg, vh)), k, x, Empty -> Empty
    | Empty, k, x, Branch (B, va, vb, vc, vd) -> Empty
    | Branch (R, ve, vf, vg, Empty), k, x, Branch (B, va, vb, vc, vd) -> Empty
    | Branch (R, ve, vf, vg, Branch (R, vi, vj, vk, vl)), k, x,
        Branch (B, va, vb, vc, vd)
        -> Empty;;

let rec balance_left
  x0 s y c = match x0, s, y, c with
    Branch (R, a, k, x, b), s, y, c ->
      Branch (R, Branch (B, a, k, x, b), s, y, c)
    | Empty, k, x, Branch (B, a, s, y, b) ->
        balance Empty k x (Branch (R, a, s, y, b))
    | Branch (B, va, vb, vc, vd), k, x, Branch (B, a, s, y, b) ->
        balance (Branch (B, va, vb, vc, vd)) k x (Branch (R, a, s, y, b))
    | Empty, k, x, Branch (R, Branch (B, a, s, y, b), t, z, c) ->
        Branch (R, Branch (B, Empty, k, x, a), s, y, balance b t z (paint R c))
    | Branch (B, va, vb, vc, vd), k, x,
        Branch (R, Branch (B, a, s, y, b), t, z, c)
        -> Branch
             (R, Branch (B, Branch (B, va, vb, vc, vd), k, x, a), s, y,
               balance b t z (paint R c))
    | Empty, k, x, Empty -> Empty
    | Empty, k, x, Branch (R, Empty, vb, vc, vd) -> Empty
    | Empty, k, x, Branch (R, Branch (R, ve, vf, vg, vh), vb, vc, vd) -> Empty
    | Branch (B, va, vb, vc, vd), k, x, Empty -> Empty
    | Branch (B, va, vb, vc, vd), k, x, Branch (R, Empty, vf, vg, vh) -> Empty
    | Branch (B, va, vb, vc, vd), k, x,
        Branch (R, Branch (R, vi, vj, vk, vl), vf, vg, vh)
        -> Empty;;

let rec combine
  xa0 x = match xa0, x with Empty, x -> x
    | Branch (v, va, vb, vc, vd), Empty -> Branch (v, va, vb, vc, vd)
    | Branch (R, a, k, x, b), Branch (R, c, s, y, d) ->
        (match combine b c
          with Empty -> Branch (R, a, k, x, Branch (R, Empty, s, y, d))
          | Branch (R, b2, t, z, c2) ->
            Branch (R, Branch (R, a, k, x, b2), t, z, Branch (R, c2, s, y, d))
          | Branch (B, b2, t, z, c2) ->
            Branch (R, a, k, x, Branch (R, Branch (B, b2, t, z, c2), s, y, d)))
    | Branch (B, a, k, x, b), Branch (B, c, s, y, d) ->
        (match combine b c
          with Empty -> balance_left a k x (Branch (B, Empty, s, y, d))
          | Branch (R, b2, t, z, c2) ->
            Branch (R, Branch (B, a, k, x, b2), t, z, Branch (B, c2, s, y, d))
          | Branch (B, b2, t, z, c2) ->
            balance_left a k x (Branch (B, Branch (B, b2, t, z, c2), s, y, d)))
    | Branch (B, va, vb, vc, vd), Branch (R, b, k, x, c) ->
        Branch (R, combine (Branch (B, va, vb, vc, vd)) b, k, x, c)
    | Branch (R, a, k, x, b), Branch (B, va, vb, vc, vd) ->
        Branch (R, a, k, x, combine b (Branch (B, va, vb, vc, vd)));;

let rec rbt_del _A
  x xa1 = match x, xa1 with x, Empty -> Empty
    | x, Branch (c, a, y, s, b) ->
        (if less _A x y then rbt_del_from_left _A x a y s b
          else (if less _A y x then rbt_del_from_right _A x a y s b
                 else combine a b))
and rbt_del_from_left _A
  x xa1 y s b = match x, xa1, y, s, b with
    x, Branch (B, lt, z, v, rt), y, s, b ->
      balance_left (rbt_del _A x (Branch (B, lt, z, v, rt))) y s b
    | x, Empty, y, s, b -> Branch (R, rbt_del _A x Empty, y, s, b)
    | x, Branch (R, va, vb, vc, vd), y, s, b ->
        Branch (R, rbt_del _A x (Branch (R, va, vb, vc, vd)), y, s, b)
and rbt_del_from_right _A
  x a y s xa4 = match x, a, y, s, xa4 with
    x, a, y, s, Branch (B, lt, z, v, rt) ->
      balance_right a y s (rbt_del _A x (Branch (B, lt, z, v, rt)))
    | x, a, y, s, Empty -> Branch (R, a, y, s, rbt_del _A x Empty)
    | x, a, y, s, Branch (R, va, vb, vc, vd) ->
        Branch (R, a, y, s, rbt_del _A x (Branch (R, va, vb, vc, vd)));;

let rec rbt_delete _A k t = paint B (rbt_del _A k t);;

let rec impl_of _B (RBT x) = x;;

let rec delete _A
  xb xc =
    RBT (rbt_delete _A.order_linorder.preorder_order.ord_preorder xb
          (impl_of _A xc));;

let rec rbt_ins _A
  f k v x3 = match f, k, v, x3 with
    f, k, v, Empty -> Branch (R, Empty, k, v, Empty)
    | f, k, v, Branch (B, l, x, y, r) ->
        (if less _A k x then balance (rbt_ins _A f k v l) x y r
          else (if less _A x k then balance l x y (rbt_ins _A f k v r)
                 else Branch (B, l, x, f k y v, r)))
    | f, k, v, Branch (R, l, x, y, r) ->
        (if less _A k x then Branch (R, rbt_ins _A f k v l, x, y, r)
          else (if less _A x k then Branch (R, l, x, y, rbt_ins _A f k v r)
                 else Branch (R, l, x, f k y v, r)));;

let rec rbt_insert_with_key _A f k v t = paint B (rbt_ins _A f k v t);;

let rec rbt_insert _A = rbt_insert_with_key _A (fun _ _ nv -> nv);;

let rec insert _A
  xc xd xe =
    RBT (rbt_insert _A.order_linorder.preorder_order.ord_preorder xc xd
          (impl_of _A xe));;

let rec rbt_lookup _A
  x0 k = match x0, k with Empty, k -> None
    | Branch (uu, l, x, y, r), k ->
        (if less _A k x then rbt_lookup _A l k
          else (if less _A x k then rbt_lookup _A r k else Some y));;

let rec lookup _A
  x = rbt_lookup _A.order_linorder.preorder_order.ord_preorder (impl_of _A x);;

let rec member _A x0 y = match x0, y with [], y -> false
                    | x :: xs, y -> eq _A x y || member _A xs y;;

let rec distinct _A = function [] -> true
                      | x :: xs -> not (member _A xs x) && distinct _A xs;;

let rec snd (x1, x2) = x2;;

let rec fst (x1, x2) = x1;;

let rec nempI _A s = less_eq _A (fst s) (snd s);;

let rec worklist
  b f x2 = match b, f, x2 with
    b, f, (s, e :: wl) ->
      (if b s then (let (sa, n) = f s e in worklist b f (sa, n @ wl))
        else (s, e :: wl))
    | b, f, (s, []) -> (s, []);;

let rec ltsga_image
  imf f =
    imf f (fun _ -> true) (fun _ -> true) (fun _ -> true) (fun _ -> true);;

let rec the (Some x2) = x2;;

let rec apsnd f (x, y) = (x, f y);;

let rec intersectI _A _B
  s1 s2 =
    ((if less _A (fst s1) (fst s2) then fst s2 else fst s1),
      (if less _B (snd s1) (snd s2) then snd s1 else snd s2));;

let rec iterate_to_list it = it (fun _ -> true) (fun a b -> a :: b) [];;

let rec ltsga_to_list it = comp iterate_to_list it;;

let rec ltsga_iterator
  it = it (fun _ -> true) (fun _ -> true) (fun _ -> true) (fun _ -> true);;

let rec rm_iterateoi
  x0 c f sigma = match x0, c, f, sigma with Empty, c, f, sigma -> sigma
    | Branch (col, l, k, v, r), c, f, sigma ->
        (if c sigma
          then (let sigmaa = rm_iterateoi l c f sigma in
                 (if c sigmaa then rm_iterateoi r c f (f (k, v) sigmaa)
                   else sigmaa))
          else sigma);;

let rec iteratei_set_op_list_it_rs_ops _A
  s = (fun c f -> rm_iterateoi (impl_of _A s) c (comp f fst));;

let rec iteratei_map_op_list_it_rm_ops _A s = rm_iterateoi (impl_of _A s);;

let rec map_iterator_key_filter
  p it =
    (fun c f ->
      it c (fun x sigma -> (if p (fst x) then f x sigma else sigma)));;

let rec map_iterator_product
  it_a it_b =
    (fun c f -> it_a c (fun a -> it_b (snd a) c (fun b -> f (fst a, b))));;

let rec set_iterator_filter
  p it = (fun c f -> it c (fun x sigma -> (if p x then f x sigma else sigma)));;

let rec map_to_set_iterator m it = it m;;

let rec ltsbm_filter_it
  it1 it2 it3 p_v1 p_e p_v2 p m1 =
    set_iterator_filter (fun (v, (e, va)) -> p_v2 va && p (v, (e, va)))
      (map_iterator_product
        (map_iterator_key_filter p_v1 (map_to_set_iterator m1 it1))
        (fun m2 ->
          map_iterator_product
            (map_iterator_key_filter p_e (map_to_set_iterator m2 it2)) it3));;

let rec ltsbm_it it1 it2 it3 = ltsga_iterator (ltsbm_filter_it it1 it2 it3);;

let rec rs_lts_it _A _B _C
  = ltsbm_it (iteratei_map_op_list_it_rm_ops _A)
      (iteratei_map_op_list_it_rm_ops _B) (iteratei_set_op_list_it_rs_ops _C);;

let rec divmod_integer
  k l = (if Z.equal k Z.zero then (Z.zero, Z.zero)
          else (if Z.lt Z.zero l
                 then (if Z.lt Z.zero k
                        then (fun k l -> if Z.equal Z.zero l then
                               (Z.zero, l) else Z.div_rem (Z.abs k) (Z.abs l))
                               k l
                        else (let (r, s) =
                                (fun k l -> if Z.equal Z.zero l then
                                  (Z.zero, l) else Z.div_rem (Z.abs k)
                                  (Z.abs l))
                                  k l
                                in
                               (if Z.equal s Z.zero then (Z.neg r, Z.zero)
                                 else (Z.sub (Z.neg r) (Z.of_int 1),
Z.sub l s))))
                 else (if Z.equal l Z.zero then (Z.zero, k)
                        else apsnd Z.neg
                               (if Z.lt k Z.zero
                                 then (fun k l -> if Z.equal Z.zero l then
(Z.zero, l) else Z.div_rem (Z.abs k) (Z.abs l))
k l
                                 else (let (r, s) =
 (fun k l -> if Z.equal Z.zero l then (Z.zero, l) else Z.div_rem (Z.abs k)
   (Z.abs l))
   k l
 in
(if Z.equal s Z.zero then (Z.neg r, Z.zero)
  else (Z.sub (Z.neg r) (Z.of_int 1), Z.sub (Z.neg l) s)))))));;

let rec divide_integer k l = fst (divmod_integer k l);;

let rec divide_nat
  m n = Nat (divide_integer (integer_of_nat m) (integer_of_nat n));;

let rec times_nat m n = Nat (Z.mul (integer_of_nat m) (integer_of_nat n));;

let rec max _A a b = (if less_eq _A a b then b else a);;

let rec nat_of_integer k = Nat (max ord_integer Z.zero k);;

let rec triangle
  n = divide_nat (times_nat n (suc n)) (nat_of_integer (Z.of_int 2));;

let rec empty_rm_basic_ops _A = (fun _ -> empty _A);;

let rec ins_rm_basic_ops _A x s = insert _A x () s;;

let rec g_sng_dflt_basic_oops_rm_basic_ops _A
  x = ins_rm_basic_ops _A x (empty_rm_basic_ops _A ());;

let rec g_sng_rm_basic_ops _A k v = insert _A k v (empty _A);;

let rec rs_lts_add _A _B
  = (fun v w va l ->
      (match lookup _A l v
        with None ->
          insert _A v
            (g_sng_rm_basic_ops _B w (g_sng_dflt_basic_oops_rm_basic_ops _A va))
            l
        | Some m2 ->
          (match lookup _B m2 w
            with None ->
              insert _A v
                (insert _B w (g_sng_dflt_basic_oops_rm_basic_ops _A va) m2) l
            | Some s3 ->
              insert _A v (insert _B w (ins_rm_basic_ops _A va s3) m2) l)));;

let rec whilea b c s = (if b s then whilea b c (c s) else s);;

let rec ltsga_image_filter
  e a it f p_v1 p_e p_v2 p l =
    it p_v1 p_e p_v2 p l (fun _ -> true)
      (fun vev la -> (let (v, (ea, va)) = f vev in a v ea va la))
      e;;

let rec rs_lts_empty _A _B = empty _A;;

let rec rs_lts_filter_it _A _B _C
  = ltsbm_filter_it (iteratei_map_op_list_it_rm_ops _A)
      (iteratei_map_op_list_it_rm_ops _B) (iteratei_set_op_list_it_rs_ops _C);;

let rec rs_lts_image_filter _A _B _C _D
  = ltsga_image_filter (rs_lts_empty _C _D) (rs_lts_add _C _D)
      (rs_lts_filter_it _A _B _A);;

let rec rs_lts_image _A _B _C _D
  = ltsga_image (rs_lts_image_filter _A _B _C _D);;

let rec prod_encode x = (fun (m, n) -> plus_nat (triangle (plus_nat m n)) m) x;;

let zero_nat : nat = Nat Z.zero;;

let rec set_iterator_emp c f sigma_0 = sigma_0;;

let rec rs_lts_succ_it _A _B
  = (fun m1 v _ ->
      (match lookup _A m1 v with None -> set_iterator_emp
        | Some m2 ->
          map_iterator_product (iteratei_map_op_list_it_rm_ops _B m2)
            (iteratei_set_op_list_it_rs_ops _A)));;

let rec rs_lts_to_list _A _B = ltsga_to_list (rs_lts_it _A _B _A);;

let rec iteratei_bset_op_list_it_dflt_basic_oops_rm_basic_ops _A
  s = (fun c f -> rm_iterateoi (impl_of _A s) c (comp f fst));;

let rec g_to_list_dflt_basic_oops_rm_basic_ops _A
  s = iteratei_bset_op_list_it_dflt_basic_oops_rm_basic_ops _A s (fun _ -> true)
        (fun a b -> a :: b) [];;

let rec g_isEmpty_dflt_basic_oops_rm_basic_ops _A
  s = iteratei_bset_op_list_it_dflt_basic_oops_rm_basic_ops _A s (fun c -> c)
        (fun _ _ -> false) true;;

let rec ins_dj_rm_basic_ops _A x s = insert _A x () s;;

let rec memb_rm_basic_ops _A x s = not (is_none (lookup _A s x));;

let rec g_inter_dflt_basic_oops_rm_basic_ops _A
  s1 s2 =
    iteratei_bset_op_list_it_dflt_basic_oops_rm_basic_ops _A s1 (fun _ -> true)
      (fun x s ->
        (if memb_rm_basic_ops _A x s2 then ins_dj_rm_basic_ops _A x s else s))
      (empty_rm_basic_ops _A ());;

let rec set_iterator_union
  it_a it_b = (fun c f sigma_0 -> it_b c f (it_a c f sigma_0));;

let rec rs_lts_succ_label_it _A _B
  = (fun m1 v ->
      (match lookup _A m1 v with None -> set_iterator_emp
        | Some m2 ->
          map_iterator_product (iteratei_map_op_list_it_rm_ops _B m2)
            (iteratei_set_op_list_it_rs_ops _A)));;

let rec set_iterator_image_filter
  g it =
    (fun c f ->
      it c (fun x sigma ->
             (match g x with None -> sigma | Some xa -> f xa sigma)));;

let rec rs_lts_connect_it _A _B _C
  = (fun m1 sa si v ->
      (match lookup _A m1 v with None -> (fun _ _ sigma_0 -> sigma_0)
        | Some m2 ->
          map_iterator_product
            (set_iterator_image_filter
              (fun a ->
                (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops _A
                          (g_inter_dflt_basic_oops_rm_basic_ops _A (snd a) sa))
                  then Some a else None))
              (iteratei_map_op_list_it_rm_ops _B m2))
            (fun _ -> iteratei_set_op_list_it_rs_ops _C si)));;

let rec rs_nfa_concate (_A1, _A2) _B
  (q1, (d1, (i1, f1))) (q2, (d2, (i2, f2))) =
    (let a =
       foldl (fun (a, b) ->
               (let (qm, n) = a in
                 (fun is q ->
                   ((insert _A2 (id q) (states_enumerate _A1 n) qm, suc n),
                     ins_dj_rm_basic_ops _A2 (states_enumerate _A1 n) is)))
                 b)
         ((empty _A2, zero_nat), empty_rm_basic_ops _A2 ())
         (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops _A2
                   (g_inter_dflt_basic_oops_rm_basic_ops _A2 i1 f1))
           then g_to_list_dflt_basic_oops_rm_basic_ops _A2 i1 @
                  g_to_list_dflt_basic_oops_rm_basic_ops _A2 i2
           else g_to_list_dflt_basic_oops_rm_basic_ops _A2 i1)
       in
     let (aa, b) = a in
      (let (qm, n) = aa in
        (fun is ->
          (let ab =
             worklist (fun _ -> true)
               (fun (ab, ba) ->
                 (let (qma, na) = ab in
                   (fun (qs, (dd, (isa, fs))) q ->
                     (let r = the (lookup _A2 qma (id q)) in
                       (if memb_rm_basic_ops _A2 r qs
                         then (((qma, na), (qs, (dd, (isa, fs)))), [])
                         else (let ac =
                                 set_iterator_union
                                   (rs_lts_succ_label_it _A2
                                     (linorder_prod _B _B) d1 q)
                                   (set_iterator_union
                                     (rs_lts_succ_label_it _A2
                                       (linorder_prod _B _B) d2 q)
                                     (rs_lts_connect_it _A2
                                       (linorder_prod _B _B) _A2 d1 f1 i2 q))
                                   (fun _ -> true)
                                   (fun (ac, qa) (bb, c) ->
                                     (let (qmb, nb) = bb in
                                       (fun (dda, naa) ->
 (if nempI _B.order_linorder.preorder_order.ord_preorder ac
   then (let r_opt = lookup _A2 qmb (id qa) in
         let bc =
           (if is_none r_opt
             then (let ra = states_enumerate _A1 nb in
                    ((insert _A2 (id qa) ra qmb, suc nb), ra))
             else ((qmb, nb), the r_opt))
           in
         let (bd, ca) = bc in
          (let (qmc, nc) = bd in
            (fun ra ->
              ((qmc, nc),
                (rs_lts_add _A2 (linorder_prod _B _B) r ac ra dda, qa :: naa))))
            ca)
   else ((qmb, nb), (dda, naa)))))
                                       c)
                                   ((qma, na), (dd, []))
                                 in
                               let (ad, bb) = ac in
                                (let (qmb, nb) = ad in
                                  (fun (dda, ae) ->
                                    (((qmb, nb),
                                       (ins_dj_rm_basic_ops _A2 r qs,
 (dda, (isa, (if memb_rm_basic_ops _A2 q f2 then ins_dj_rm_basic_ops _A2 r fs
               else fs))))),
                                      ae)))
                                  bb)))))
                   ba)
               (((qm, n),
                  (empty_rm_basic_ops _A2 (),
                    (rs_lts_empty _A2 (linorder_prod _B _B),
                      (is, empty_rm_basic_ops _A2 ())))),
                 (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops _A2
                           (g_inter_dflt_basic_oops_rm_basic_ops _A2 i1 f1))
                   then g_to_list_dflt_basic_oops_rm_basic_ops _A2 i1 @
                          g_to_list_dflt_basic_oops_rm_basic_ops _A2 i2
                   else g_to_list_dflt_basic_oops_rm_basic_ops _A2 i1))
             in
           let (ac, ba) = ab in
            (let (_, aaa) = ac in (fun _ -> aaa)) ba)))
        b);;

let rec ltsga_to_collect_list to_list l = to_list l;;

let rec rs_lts_to_collect_list _A _B
  = ltsga_to_collect_list (rs_lts_to_list _A _B);;

let rec rs_nfa_destruct (_A1, _A2) _B
  (q, (d, (i, f))) =
    (g_to_list_dflt_basic_oops_rm_basic_ops _A2 q,
      (rs_lts_to_collect_list _A2 (linorder_prod _B _B) d,
        (g_to_list_dflt_basic_oops_rm_basic_ops _A2 i,
          g_to_list_dflt_basic_oops_rm_basic_ops _A2 f)));;

let rec rs_nfa_bool_comb (_A1, _A2) _B
  bc (q1, (d1, (i1, f1))) (q2, (d2, (i2, f2))) =
    (let a =
       foldl (fun (a, b) ->
               (let (qm, n) = a in
                 (fun is q ->
                   ((insert (linorder_prod _A2 _A2) (id q)
                       (states_enumerate _A1 n) qm,
                      suc n),
                     ins_dj_rm_basic_ops _A2 (states_enumerate _A1 n) is)))
                 b)
         ((empty (linorder_prod _A2 _A2), zero_nat), empty_rm_basic_ops _A2 ())
         (product (g_to_list_dflt_basic_oops_rm_basic_ops _A2 i1)
           (g_to_list_dflt_basic_oops_rm_basic_ops _A2 i2))
       in
     let (aa, b) = a in
      (let (qm, n) = aa in
        (fun is ->
          (let ab =
             worklist (fun _ -> true)
               (fun (ab, ba) ->
                 (let (qma, na) = ab in
                   (fun (qs, (dd, (isa, fs))) q ->
                     (let r = the (lookup (linorder_prod _A2 _A2) qma (id q)) in
                       (if memb_rm_basic_ops _A2 r qs
                         then (((qma, na), (qs, (dd, (isa, fs)))), [])
                         else (let ac =
                                 (let (q1a, q2a) = q in
                                   (fun c f ->
                                     rs_lts_succ_label_it _A2
                                       (linorder_prod _B _B) d1 q1a c
                                       (fun (a1, q1b) ->
 rs_lts_succ_it _A2 (linorder_prod _B _B) d2 q2a a1 c
   (fun (a2, q2b) -> f ((a1, a2), (q1b, q2b))))))
                                   (fun _ -> true)
                                   (fun (ac, qa) (bb, c) ->
                                     (let (qmb, nb) = bb in
                                       (fun (dda, naa) ->
 (if nempI _B.order_linorder.preorder_order.ord_preorder
       (intersectI _B.order_linorder.preorder_order.ord_preorder
         _B.order_linorder.preorder_order.ord_preorder (fst ac) (snd ac))
   then (let r_opt = lookup (linorder_prod _A2 _A2) qmb (id qa) in
         let bd =
           (if is_none r_opt
             then (let ra = states_enumerate _A1 nb in
                    ((insert (linorder_prod _A2 _A2) (id qa) ra qmb, suc nb),
                      ra))
             else ((qmb, nb), the r_opt))
           in
         let (be, ca) = bd in
          (let (qmc, nc) = be in
            (fun ra ->
              ((qmc, nc),
                (rs_lts_add _A2 (linorder_prod _B _B) r
                   (intersectI _B.order_linorder.preorder_order.ord_preorder
                     _B.order_linorder.preorder_order.ord_preorder (fst ac)
                     (snd ac))
                   ra dda,
                  qa :: naa))))
            ca)
   else ((qmb, nb), (dda, naa)))))
                                       c)
                                   ((qma, na), (dd, []))
                                 in
                               let (ad, bb) = ac in
                                (let (qmb, nb) = ad in
                                  (fun (dda, ae) ->
                                    (((qmb, nb),
                                       (ins_dj_rm_basic_ops _A2 r qs,
 (dda, (isa, (if (let (q1a, q2a) = q in
                   bc (memb_rm_basic_ops _A2 q1a f1)
                     (memb_rm_basic_ops _A2 q2a f2))
               then ins_dj_rm_basic_ops _A2 r fs else fs))))),
                                      ae)))
                                  bb)))))
                   ba)
               (((qm, n),
                  (empty_rm_basic_ops _A2 (),
                    (rs_lts_empty _A2 (linorder_prod _B _B),
                      (is, empty_rm_basic_ops _A2 ())))),
                 product (g_to_list_dflt_basic_oops_rm_basic_ops _A2 i1)
                   (g_to_list_dflt_basic_oops_rm_basic_ops _A2 i2))
             in
           let (ac, ba) = ab in
            (let (_, aaa) = ac in (fun _ -> aaa)) ba)))
        b);;

let rec delete_rm_basic_ops _A x s = delete _A x s;;

let rec lookup_aux _A v rc = lookup _A rc v;;

let rec alpha_rm_basic_ops (_A1, _A2) s = dom _A1 (lookup _A2 s);;

let rec rs_indegree (_A1, _A2)
  s rc =
    (let x =
       iteratei_set_op_list_it_rs_ops _A2 s (fun _ -> true)
         (fun x sigma ->
           (let xa =
              (if not (is_none (lookup _A2 rc x))
                then iteratei_set_op_list_it_rs_ops (linorder_prod _A2 _A2)
                       (the (lookup_aux _A2 x rc)) (fun _ -> true)
                       (fun xa sigmaa -> fst xa :: snd xa :: sigmaa) []
                else [])
              in
             xa @ sigma))
         []
       in
      (if distinct _A1 x then true else false));;

let rec tri_union_iterator
  it_1 it_2 it_3 =
    (fun q ->
      set_iterator_union (it_1 q) (set_iterator_union (it_2 q) (it_3 q)));;

let rec concat_impl_aux
  c_inter c_nempty const f it_1 it_2 it_3 i1a i2a i1 f1 i2 fP1 fP2 =
    (fun aA1 aA2 ->
      const f
        (if c_nempty (c_inter (i1 aA1) (f1 aA1)) then i1a aA1 @ i2a aA2
          else i1a aA1)
        (fP2 aA2)
        (tri_union_iterator (it_1 aA1) (it_2 aA2)
          (it_3 aA1 (fP1 aA1) (i2 aA2))));;

let rec iteratei_bmap_op_list_it_rm_basic_ops _A
  s = rm_iterateoi (impl_of _A s);;

let rec g_to_list_rm_basic_ops _A
  m = iteratei_bmap_op_list_it_rm_basic_ops _A m (fun _ -> true)
        (fun a b -> a :: b) [];;

let rec rename_states_gen_impl
  im im2 (q, (d, (i, f))) =
    (fun fa ->
      (im fa q,
        (im2 (fun qaq -> (fa (fst qaq), (fst (snd qaq), fa (snd (snd qaq))))) d,
          (im fa i, im fa f))));;

let rec nfa_acceptingp a = snd (snd (snd a));;

let rec nfa_initialp a = fst (snd (snd a));;

let rec nfa_transp a = fst (snd a);;

let rec concat_rename_impl_aux
  c_inter c_nempty const f it_1 it_2 it_3 i1a i2a i1 f1a i2 fP1 fP2 rename1
    rename2 f1 f2 =
    (fun a1 a2 ->
      (let aA1 = rename1 a1 f1 in
       let a = rename2 a2 f2 in
        concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 i1a i2a i1 f1a
          i2 fP1 fP2 aA1 a));;

let rec rs_nfa_concate_rename (_A1, _A2) _B
  f1a f2a (q1, (d1, (i1, f1))) (q2, (d2, (i2, f2))) =
    concat_rename_impl_aux
      (g_inter_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2))
      (fun x ->
        not (g_isEmpty_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2) x))
      (fun ff i fp d_it ->
        (let a =
           foldl (fun (a, b) ->
                   (let (qm, n) = a in
                     (fun is q ->
                       ((insert (linorder_prod _A2 _A2) (ff q)
                           (states_enumerate _A1 n) qm,
                          suc n),
                         ins_dj_rm_basic_ops _A2 (states_enumerate _A1 n) is)))
                     b)
             ((empty (linorder_prod _A2 _A2), zero_nat),
               empty_rm_basic_ops _A2 ())
             i
           in
         let (aa, b) = a in
          (let (qm, n) = aa in
            (fun is ->
              (let ab =
                 worklist (fun _ -> true)
                   (fun (ab, ba) ->
                     (let (qma, na) = ab in
                       (fun (qs, (dd, (isa, fs))) q ->
                         (let r =
                            the (lookup (linorder_prod _A2 _A2) qma (ff q)) in
                           (if memb_rm_basic_ops _A2 r qs
                             then (((qma, na), (qs, (dd, (isa, fs)))), [])
                             else (let ac =
                                     d_it q (fun _ -> true)
                                       (fun (ac, qa) (bb, c) ->
 (let (qmb, nb) = bb in
   (fun (dda, naa) ->
     (if nempI _B.order_linorder.preorder_order.ord_preorder ac
       then (let r_opt = lookup (linorder_prod _A2 _A2) qmb (ff qa) in
             let bc =
               (if is_none r_opt
                 then (let ra = states_enumerate _A1 nb in
                        ((insert (linorder_prod _A2 _A2) (ff qa) ra qmb,
                           suc nb),
                          ra))
                 else ((qmb, nb), the r_opt))
               in
             let (bd, ca) = bc in
              (let (qmc, nc) = bd in
                (fun ra ->
                  ((qmc, nc),
                    (rs_lts_add _A2 (linorder_prod _B _B) r ac ra dda,
                      qa :: naa))))
                ca)
       else ((qmb, nb), (dda, naa)))))
   c)
                                       ((qma, na), (dd, []))
                                     in
                                   let (ad, bb) = ac in
                                    (let (qmb, nb) = ad in
                                      (fun (dda, ae) ->
(((qmb, nb),
   (ins_dj_rm_basic_ops _A2 r qs,
     (dda, (isa, (if fp q then ins_dj_rm_basic_ops _A2 r fs else fs))))),
  ae)))
                                      bb)))))
                       ba)
                   (((qm, n),
                      (empty_rm_basic_ops _A2 (),
                        (rs_lts_empty _A2 (linorder_prod _B _B),
                          (is, empty_rm_basic_ops _A2 ())))),
                     i)
                 in
               let (ac, ba) = ab in
                (let (_, aaa) = ac in (fun _ -> aaa)) ba)))
            b))
      id (fun a ->
           rs_lts_succ_label_it (linorder_prod _A2 _A2) (linorder_prod _B _B)
             (nfa_transp a))
      (fun a ->
        rs_lts_succ_label_it (linorder_prod _A2 _A2) (linorder_prod _B _B)
          (nfa_transp a))
      (fun a ->
        rs_lts_connect_it (linorder_prod _A2 _A2) (linorder_prod _B _B)
          (linorder_prod _A2 _A2) (nfa_transp a))
      (fun a ->
        g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
          (nfa_initialp a))
      (fun a ->
        g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
          (nfa_initialp a))
      nfa_initialp nfa_acceptingp nfa_initialp nfa_acceptingp
      (fun a q ->
        memb_rm_basic_ops (linorder_prod _A2 _A2) q (nfa_acceptingp a))
      (rename_states_gen_impl
        (fun f s ->
          iteratei_set_op_list_it_rs_ops _A2 s (fun _ -> true)
            (fun b -> ins_rm_basic_ops (linorder_prod _A2 _A2) (f b))
            (empty_rm_basic_ops (linorder_prod _A2 _A2) ()))
        (rs_lts_image _A2 (linorder_prod _B _B) (linorder_prod _A2 _A2)
          (linorder_prod _B _B)))
      (rename_states_gen_impl
        (fun f s ->
          iteratei_set_op_list_it_rs_ops _A2 s (fun _ -> true)
            (fun b -> ins_rm_basic_ops (linorder_prod _A2 _A2) (f b))
            (empty_rm_basic_ops (linorder_prod _A2 _A2) ()))
        (rs_lts_image _A2 (linorder_prod _B _B) (linorder_prod _A2 _A2)
          (linorder_prod _B _B)))
      f1a f2a (q1, (d1, (i1, f1))) (q2, (d2, (i2, f2)));;

let rec rs_S_to_list _A s = g_to_list_dflt_basic_oops_rm_basic_ops _A s;;

let rec set_iterator_product
  it_a it_b = (fun c f -> it_a c (fun a -> it_b a c (fun b -> f (a, b))));;

let rec set_iterator_image g it = (fun c f -> it c (fun x -> f (g x)));;

let rec product_iterator
  it_1 it_2 =
    (fun (q1, q2) ->
      set_iterator_image
        (fun (a, b) ->
          (let (a1, q1a) = a in (fun (a2, q2a) -> ((a1, a2), (q1a, q2a)))) b)
        (set_iterator_product (it_1 q1) (fun aq -> it_2 q2 (fst aq))));;

let rec rs_rc_to_list (_A1, _A2)
  l = foldl (fun l1 s ->
              (fst s,
                alpha_rm_basic_ops
                  ((enum_prod _A1 _A1), (linorder_prod _A2 _A2)) (snd s)) ::
                l1)
        [] (g_to_list_rm_basic_ops _A2 l);;

let rec rs_rm_to_list _A (_B1, _B2) _C l = g_to_list_rm_basic_ops _A l;;

let rec g_from_list_aux_dflt_basic_oops_rm_basic_ops _A
  accs x1 = match accs, x1 with
    accs, x :: l ->
      g_from_list_aux_dflt_basic_oops_rm_basic_ops _A
        (ins_rm_basic_ops _A x accs) l
    | y, [] -> y;;

let rec g_from_list_dflt_basic_oops_rm_basic_ops _A
  l = g_from_list_aux_dflt_basic_oops_rm_basic_ops _A (empty_rm_basic_ops _A ())
        l;;

let rec rs_nfa_construct_interval (_A1, _A2) _B
  (ql, (dl, (il, fl))) =
    foldl (fun (q, (d, (i, f))) (q1, (l, q2)) ->
            (ins_rm_basic_ops _A2 q1 (ins_rm_basic_ops _A2 q2 q),
              (rs_lts_add _A2 (linorder_prod _B _B) q1 l q2 d, (i, f))))
      (g_from_list_dflt_basic_oops_rm_basic_ops _A2 (ql @ il @ fl),
        (rs_lts_empty _A2 (linorder_prod _B _B),
          (g_from_list_dflt_basic_oops_rm_basic_ops _A2 il,
            g_from_list_dflt_basic_oops_rm_basic_ops _A2 fl)))
      dl;;

let rec rs_nfa_construct_reachable (_A1, _A2) _B
  (q2, (d2, (i2, f2))) =
    (let a =
       foldl (fun (a, b) ->
               (let (qm, n) = a in
                 (fun is q ->
                   ((insert _A2 (id q) (states_enumerate _A1 n) qm, suc n),
                     ins_dj_rm_basic_ops _A2 (states_enumerate _A1 n) is)))
                 b)
         ((empty _A2, zero_nat), empty_rm_basic_ops _A2 ())
         (g_to_list_dflt_basic_oops_rm_basic_ops _A2 i2)
       in
     let (aa, b) = a in
      (let (qm, n) = aa in
        (fun is ->
          (let ab =
             worklist (fun _ -> true)
               (fun (ab, ba) ->
                 (let (qma, na) = ab in
                   (fun (qs, (dd, (isa, fs))) q ->
                     (let r = the (lookup _A2 qma (id q)) in
                       (if memb_rm_basic_ops _A2 r qs
                         then (((qma, na), (qs, (dd, (isa, fs)))), [])
                         else (let ac =
                                 rs_lts_succ_label_it _A2 (linorder_prod _B _B)
                                   d2 q (fun _ -> true)
                                   (fun (ac, qa) (bb, c) ->
                                     (let (qmb, nb) = bb in
                                       (fun (dda, naa) ->
 (if nempI _B.order_linorder.preorder_order.ord_preorder ac
   then (let r_opt = lookup _A2 qmb (id qa) in
         let bc =
           (if is_none r_opt
             then (let ra = states_enumerate _A1 nb in
                    ((insert _A2 (id qa) ra qmb, suc nb), ra))
             else ((qmb, nb), the r_opt))
           in
         let (bd, ca) = bc in
          (let (qmc, nc) = bd in
            (fun ra ->
              ((qmc, nc),
                (rs_lts_add _A2 (linorder_prod _B _B) r ac ra dda, qa :: naa))))
            ca)
   else ((qmb, nb), (dda, naa)))))
                                       c)
                                   ((qma, na), (dd, []))
                                 in
                               let (ad, bb) = ac in
                                (let (qmb, nb) = ad in
                                  (fun (dda, ae) ->
                                    (((qmb, nb),
                                       (ins_dj_rm_basic_ops _A2 r qs,
 (dda, (isa, (if memb_rm_basic_ops _A2 q f2 then ins_dj_rm_basic_ops _A2 r fs
               else fs))))),
                                      ae)))
                                  bb)))))
                   ba)
               (((qm, n),
                  (empty_rm_basic_ops _A2 (),
                    (rs_lts_empty _A2 (linorder_prod _B _B),
                      (is, empty_rm_basic_ops _A2 ())))),
                 g_to_list_dflt_basic_oops_rm_basic_ops _A2 i2)
             in
           let (ac, ba) = ab in
            (let (_, aaa) = ac in (fun _ -> aaa)) ba)))
        b);;

let rec rs_gen_S_from_list _A
  l = foldl (fun s a -> ins_rm_basic_ops _A a s) (empty_rm_basic_ops _A ()) l;;

let rec rename_states_impl im im2 = rename_states_gen_impl im im2;;

let rec g_ball_dflt_basic_oops_rm_basic_ops _A
  s p = iteratei_bset_op_list_it_dflt_basic_oops_rm_basic_ops _A s (fun c -> c)
          (fun x _ -> p x) true;;

let rec g_subset_dflt_basic_oops_rm_basic_ops _A
  s1 s2 =
    g_ball_dflt_basic_oops_rm_basic_ops _A s1
      (fun x -> memb_rm_basic_ops _A x s2);;

let rec g_union_dflt_basic_oops_rm_basic_ops _A
  s1 s2 =
    iteratei_bset_op_list_it_dflt_basic_oops_rm_basic_ops _A s1 (fun _ -> true)
      (ins_rm_basic_ops _A) s2;;

let rec g_diff_dflt_basic_oops_rm_basic_ops _A
  s1 s2 =
    iteratei_bset_op_list_it_dflt_basic_oops_rm_basic_ops _A s2 (fun _ -> true)
      (delete_rm_basic_ops _A) s1;;

let rec rs_forward_analysis (_A1, _A2) _B _C
  rm = (fun b si rc rma ->
         whilea
           (fun p -> not (g_isEmpty_dflt_basic_oops_rm_basic_ops _B (fst p)))
           (fun x ->
             (let xa =
                iteratei_set_op_list_it_rs_ops _B (fst x) (fun _ -> true)
                  (fun xa sigma ->
                    (let xb =
                       (if not (is_none (lookup _B rc xa))
                         then iteratei_set_op_list_it_rs_ops
                                (linorder_prod _B _B)
                                (the (lookup_aux _B xa rc)) (fun _ -> true)
                                (fun xb sigmaa ->
                                  ins_rm_basic_ops _B (fst xb)
                                    (ins_rm_basic_ops _B (snd xb) sigmaa))
                                (empty_rm_basic_ops _B ())
                         else empty_rm_basic_ops _B ())
                       in
                      (if g_subset_dflt_basic_oops_rm_basic_ops _B xb
                            (snd (snd x))
                        then ins_rm_basic_ops _B xa sigma else sigma)))
                  (empty_rm_basic_ops _B ())
                in
              let xb =
                iteratei_set_op_list_it_rs_ops _B xa (fun _ -> true)
                  (fun xb sigma ->
                    (if not (is_none (lookup _B rc xb))
                      then (let xc =
                              iteratei_set_op_list_it_rs_ops
                                (linorder_prod _B _B)
                                (the (lookup_aux _B xb rc)) (fun _ -> true)
                                (fun xc sigmaa ->
                                  (let p =
                                     foldl (fun p q ->
     ((insert (linorder_prod _A2 _A2) (id q)
         (states_enumerate _A1 (snd (fst p))) (fst (fst p)),
        suc (snd (fst p))),
       ins_dj_rm_basic_ops _A2 (states_enumerate _A1 (snd (fst p))) (snd p)))
                                       ((empty (linorder_prod _A2 _A2),
  zero_nat),
 empty_rm_basic_ops _A2 ())
                                       (product
 (g_to_list_dflt_basic_oops_rm_basic_ops _A2 (fst (snd (snd sigmaa))))
 (g_to_list_dflt_basic_oops_rm_basic_ops _A2
   (fst (snd (snd (let nA1 =
                     rename_states_impl
                       (fun f s ->
                         iteratei_set_op_list_it_rs_ops _A2 s (fun _ -> true)
                           (fun ba ->
                             ins_rm_basic_ops (linorder_prod _A2 _A2) (f ba))
                           (empty_rm_basic_ops (linorder_prod _A2 _A2) ()))
                       (rs_lts_image _A2 (linorder_prod _C _C)
                         (linorder_prod _A2 _A2) (linorder_prod _C _C))
                       (the (lookup _B sigma (fst xc))) (fun a -> (rm, a))
                     in
                   let aA2 =
                     rename_states_impl
                       (fun f s ->
                         iteratei_set_op_list_it_rs_ops _A2 s (fun _ -> true)
                           (fun ba ->
                             ins_rm_basic_ops (linorder_prod _A2 _A2) (f ba))
                           (empty_rm_basic_ops (linorder_prod _A2 _A2) ()))
                       (rs_lts_image _A2 (linorder_prod _C _C)
                         (linorder_prod _A2 _A2) (linorder_prod _C _C))
                       (the (lookup _B sigma (snd xc))) (fun a -> (b, a))
                     in
                   let p =
                     foldl (fun p q ->
                             ((insert (linorder_prod _A2 _A2) (id q)
                                 (states_enumerate _A1 (snd (fst p)))
                                 (fst (fst p)),
                                suc (snd (fst p))),
                               ins_dj_rm_basic_ops _A2
                                 (states_enumerate _A1 (snd (fst p))) (snd p)))
                       ((empty (linorder_prod _A2 _A2), zero_nat),
                         empty_rm_basic_ops _A2 ())
                       (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops
                                 (linorder_prod _A2 _A2)
                                 (g_inter_dflt_basic_oops_rm_basic_ops
                                   (linorder_prod _A2 _A2) (nfa_initialp nA1)
                                   (nfa_acceptingp nA1)))
                         then g_to_list_dflt_basic_oops_rm_basic_ops
                                (linorder_prod _A2 _A2) (nfa_initialp nA1) @
                                g_to_list_dflt_basic_oops_rm_basic_ops
                                  (linorder_prod _A2 _A2) (nfa_initialp aA2)
                         else g_to_list_dflt_basic_oops_rm_basic_ops
                                (linorder_prod _A2 _A2) (nfa_initialp nA1))
                     in
                   let pa =
                     worklist (fun _ -> true)
                       (fun pa q ->
                         (let r =
                            the (lookup (linorder_prod _A2 _A2) (fst (fst pa))
                                  (id q))
                            in
                           (if memb_rm_basic_ops _A2 r (fst (snd pa))
                             then (pa, [])
                             else (let paa =
                                     tri_union_iterator
                                       (rs_lts_succ_label_it
 (linorder_prod _A2 _A2) (linorder_prod _C _C) (nfa_transp nA1))
                                       (rs_lts_succ_label_it
 (linorder_prod _A2 _A2) (linorder_prod _C _C) (nfa_transp aA2))
                                       (rs_lts_connect_it
 (linorder_prod _A2 _A2) (linorder_prod _C _C) (linorder_prod _A2 _A2)
 (nfa_transp nA1) (nfa_acceptingp nA1) (nfa_initialp aA2))
                                       q (fun _ -> true)
                                       (fun pb paa ->
 (if nempI _C.order_linorder.preorder_order.ord_preorder (fst pb)
   then (let r_opt =
           lookup (linorder_prod _A2 _A2) (fst (fst paa)) (id (snd pb)) in
         let pba =
           (if is_none r_opt
             then (let ra = states_enumerate _A1 (snd (fst paa)) in
                    ((insert (linorder_prod _A2 _A2) (id (snd pb)) ra
                        (fst (fst paa)),
                       suc (snd (fst paa))),
                      ra))
             else (fst paa, the r_opt))
           in
          (fst pba,
            (rs_lts_add _A2 (linorder_prod _C _C) r (fst pb) (snd pba)
               (fst (snd paa)),
              snd pb :: snd (snd paa))))
   else paa))
                                       (fst pa, (fst (snd (snd pa)), []))
                                     in
                                    ((fst paa,
                                       (ins_dj_rm_basic_ops _A2 r
  (fst (snd pa)),
 (fst (snd paa),
   (fst (snd (snd (snd pa))),
     (if memb_rm_basic_ops (linorder_prod _A2 _A2) q (nfa_acceptingp aA2)
       then ins_dj_rm_basic_ops _A2 r (snd (snd (snd (snd pa))))
       else snd (snd (snd (snd pa)))))))),
                                      snd (snd paa))))))
                       ((fst p,
                          (empty_rm_basic_ops _A2 (),
                            (rs_lts_empty _A2 (linorder_prod _C _C),
                              (snd p, empty_rm_basic_ops _A2 ())))),
                         (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops
                                   (linorder_prod _A2 _A2)
                                   (g_inter_dflt_basic_oops_rm_basic_ops
                                     (linorder_prod _A2 _A2) (nfa_initialp nA1)
                                     (nfa_acceptingp nA1)))
                           then g_to_list_dflt_basic_oops_rm_basic_ops
                                  (linorder_prod _A2 _A2) (nfa_initialp nA1) @
                                  g_to_list_dflt_basic_oops_rm_basic_ops
                                    (linorder_prod _A2 _A2) (nfa_initialp aA2)
                           else g_to_list_dflt_basic_oops_rm_basic_ops
                                  (linorder_prod _A2 _A2) (nfa_initialp nA1)))
                     in
                    snd (fst pa)))))))
                                     in
                                   let pa =
                                     worklist (fun _ -> true)
                                       (fun pa q ->
 (let r = the (lookup (linorder_prod _A2 _A2) (fst (fst pa)) (id q)) in
   (if memb_rm_basic_ops _A2 r (fst (snd pa)) then (pa, [])
     else (let paa =
             product_iterator
               (rs_lts_succ_label_it _A2 (linorder_prod _C _C)
                 (fst (snd sigmaa)))
               (rs_lts_succ_it _A2 (linorder_prod _C _C)
                 (fst (snd (let nA1 =
                              rename_states_impl
                                (fun f s ->
                                  iteratei_set_op_list_it_rs_ops _A2 s
                                    (fun _ -> true)
                                    (fun ba ->
                                      ins_rm_basic_ops (linorder_prod _A2 _A2)
(f ba))
                                    (empty_rm_basic_ops (linorder_prod _A2 _A2)
                                      ()))
                                (rs_lts_image _A2 (linorder_prod _C _C)
                                  (linorder_prod _A2 _A2) (linorder_prod _C _C))
                                (the (lookup _B sigma (fst xc)))
                                (fun a -> (rm, a))
                              in
                            let aA2 =
                              rename_states_impl
                                (fun f s ->
                                  iteratei_set_op_list_it_rs_ops _A2 s
                                    (fun _ -> true)
                                    (fun ba ->
                                      ins_rm_basic_ops (linorder_prod _A2 _A2)
(f ba))
                                    (empty_rm_basic_ops (linorder_prod _A2 _A2)
                                      ()))
                                (rs_lts_image _A2 (linorder_prod _C _C)
                                  (linorder_prod _A2 _A2) (linorder_prod _C _C))
                                (the (lookup _B sigma (snd xc)))
                                (fun a -> (b, a))
                              in
                            let pb =
                              foldl (fun pb qa ->
                                      ((insert (linorder_prod _A2 _A2) (id qa)
  (states_enumerate _A1 (snd (fst pb))) (fst (fst pb)),
 suc (snd (fst pb))),
ins_dj_rm_basic_ops _A2 (states_enumerate _A1 (snd (fst pb))) (snd pb)))
                                ((empty (linorder_prod _A2 _A2), zero_nat),
                                  empty_rm_basic_ops _A2 ())
                                (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops
  (linorder_prod _A2 _A2)
  (g_inter_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
    (nfa_initialp nA1) (nfa_acceptingp nA1)))
                                  then g_to_list_dflt_basic_oops_rm_basic_ops
 (linorder_prod _A2 _A2) (nfa_initialp nA1) @
 g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
   (nfa_initialp aA2)
                                  else g_to_list_dflt_basic_oops_rm_basic_ops
 (linorder_prod _A2 _A2) (nfa_initialp nA1))
                              in
                            let pc =
                              worklist (fun _ -> true)
                                (fun pc qa ->
                                  (let ra =
                                     the (lookup (linorder_prod _A2 _A2)
   (fst (fst pc)) (id qa))
                                     in
                                    (if memb_rm_basic_ops _A2 ra (fst (snd pc))
                                      then (pc, [])
                                      else (let paa =
      tri_union_iterator
        (rs_lts_succ_label_it (linorder_prod _A2 _A2) (linorder_prod _C _C)
          (nfa_transp nA1))
        (rs_lts_succ_label_it (linorder_prod _A2 _A2) (linorder_prod _C _C)
          (nfa_transp aA2))
        (rs_lts_connect_it (linorder_prod _A2 _A2) (linorder_prod _C _C)
          (linorder_prod _A2 _A2) (nfa_transp nA1) (nfa_acceptingp nA1)
          (nfa_initialp aA2))
        qa (fun _ -> true)
        (fun pd paa ->
          (if nempI _C.order_linorder.preorder_order.ord_preorder (fst pd)
            then (let r_opt =
                    lookup (linorder_prod _A2 _A2) (fst (fst paa)) (id (snd pd))
                    in
                  let pba =
                    (if is_none r_opt
                      then (let rb = states_enumerate _A1 (snd (fst paa)) in
                             ((insert (linorder_prod _A2 _A2) (id (snd pd)) rb
                                 (fst (fst paa)),
                                suc (snd (fst paa))),
                               rb))
                      else (fst paa, the r_opt))
                    in
                   (fst pba,
                     (rs_lts_add _A2 (linorder_prod _C _C) ra (fst pd) (snd pba)
                        (fst (snd paa)),
                       snd pd :: snd (snd paa))))
            else paa))
        (fst pc, (fst (snd (snd pc)), []))
      in
     ((fst paa,
        (ins_dj_rm_basic_ops _A2 ra (fst (snd pc)),
          (fst (snd paa),
            (fst (snd (snd (snd pc))),
              (if memb_rm_basic_ops (linorder_prod _A2 _A2) qa
                    (nfa_acceptingp aA2)
                then ins_dj_rm_basic_ops _A2 ra (snd (snd (snd (snd pc))))
                else snd (snd (snd (snd pc)))))))),
       snd (snd paa))))))
                                ((fst pb,
                                   (empty_rm_basic_ops _A2 (),
                                     (rs_lts_empty _A2 (linorder_prod _C _C),
                                       (snd pb, empty_rm_basic_ops _A2 ())))),
                                  (if not
(g_isEmpty_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
  (g_inter_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
    (nfa_initialp nA1) (nfa_acceptingp nA1)))
                                    then g_to_list_dflt_basic_oops_rm_basic_ops
   (linorder_prod _A2 _A2) (nfa_initialp nA1) @
   g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
     (nfa_initialp aA2)
                                    else g_to_list_dflt_basic_oops_rm_basic_ops
   (linorder_prod _A2 _A2) (nfa_initialp nA1)))
                              in
                             snd (fst pc)))))
               q (fun _ -> true)
               (fun pb paa ->
                 (if nempI _C.order_linorder.preorder_order.ord_preorder
                       (intersectI _C.order_linorder.preorder_order.ord_preorder
                         _C.order_linorder.preorder_order.ord_preorder
                         (fst (fst pb)) (snd (fst pb)))
                   then (let r_opt =
                           lookup (linorder_prod _A2 _A2) (fst (fst paa))
                             (id (snd pb))
                           in
                         let pba =
                           (if is_none r_opt
                             then (let ra = states_enumerate _A1 (snd (fst paa))
                                     in
                                    ((insert (linorder_prod _A2 _A2)
(id (snd pb)) ra (fst (fst paa)),
                                       suc (snd (fst paa))),
                                      ra))
                             else (fst paa, the r_opt))
                           in
                          (fst pba,
                            (rs_lts_add _A2 (linorder_prod _C _C) r
                               (intersectI
                                 _C.order_linorder.preorder_order.ord_preorder
                                 _C.order_linorder.preorder_order.ord_preorder
                                 (fst (fst pb)) (snd (fst pb)))
                               (snd pba) (fst (snd paa)),
                              snd pb :: snd (snd paa))))
                   else paa))
               (fst pa, (fst (snd (snd pa)), []))
             in
            ((fst paa,
               (ins_dj_rm_basic_ops _A2 r (fst (snd pa)),
                 (fst (snd paa),
                   (fst (snd (snd (snd pa))),
                     (if memb_rm_basic_ops _A2 (fst q)
                           (snd (snd (snd sigmaa))) &&
                           memb_rm_basic_ops _A2 (snd q)
                             (snd (snd (snd
 (let nA1 =
    rename_states_impl
      (fun f s ->
        iteratei_set_op_list_it_rs_ops _A2 s (fun _ -> true)
          (fun ba -> ins_rm_basic_ops (linorder_prod _A2 _A2) (f ba))
          (empty_rm_basic_ops (linorder_prod _A2 _A2) ()))
      (rs_lts_image _A2 (linorder_prod _C _C) (linorder_prod _A2 _A2)
        (linorder_prod _C _C))
      (the (lookup _B sigma (fst xc))) (fun a -> (rm, a))
    in
  let aA2 =
    rename_states_impl
      (fun f s ->
        iteratei_set_op_list_it_rs_ops _A2 s (fun _ -> true)
          (fun ba -> ins_rm_basic_ops (linorder_prod _A2 _A2) (f ba))
          (empty_rm_basic_ops (linorder_prod _A2 _A2) ()))
      (rs_lts_image _A2 (linorder_prod _C _C) (linorder_prod _A2 _A2)
        (linorder_prod _C _C))
      (the (lookup _B sigma (snd xc))) (fun a -> (b, a))
    in
  let pb =
    foldl (fun pb qa ->
            ((insert (linorder_prod _A2 _A2) (id qa)
                (states_enumerate _A1 (snd (fst pb))) (fst (fst pb)),
               suc (snd (fst pb))),
              ins_dj_rm_basic_ops _A2 (states_enumerate _A1 (snd (fst pb)))
                (snd pb)))
      ((empty (linorder_prod _A2 _A2), zero_nat), empty_rm_basic_ops _A2 ())
      (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
                (g_inter_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
                  (nfa_initialp nA1) (nfa_acceptingp nA1)))
        then g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
               (nfa_initialp nA1) @
               g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
                 (nfa_initialp aA2)
        else g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
               (nfa_initialp nA1))
    in
  let pc =
    worklist (fun _ -> true)
      (fun pc qa ->
        (let ra = the (lookup (linorder_prod _A2 _A2) (fst (fst pc)) (id qa)) in
          (if memb_rm_basic_ops _A2 ra (fst (snd pc)) then (pc, [])
            else (let pab =
                    tri_union_iterator
                      (rs_lts_succ_label_it (linorder_prod _A2 _A2)
                        (linorder_prod _C _C) (nfa_transp nA1))
                      (rs_lts_succ_label_it (linorder_prod _A2 _A2)
                        (linorder_prod _C _C) (nfa_transp aA2))
                      (rs_lts_connect_it (linorder_prod _A2 _A2)
                        (linorder_prod _C _C) (linorder_prod _A2 _A2)
                        (nfa_transp nA1) (nfa_acceptingp nA1)
                        (nfa_initialp aA2))
                      qa (fun _ -> true)
                      (fun pd pab ->
                        (if nempI _C.order_linorder.preorder_order.ord_preorder
                              (fst pd)
                          then (let r_opt =
                                  lookup (linorder_prod _A2 _A2) (fst (fst pab))
                                    (id (snd pd))
                                  in
                                let pba =
                                  (if is_none r_opt
                                    then (let rb =
    states_enumerate _A1 (snd (fst pab)) in
   ((insert (linorder_prod _A2 _A2) (id (snd pd)) rb (fst (fst pab)),
      suc (snd (fst pab))),
     rb))
                                    else (fst pab, the r_opt))
                                  in
                                 (fst pba,
                                   (rs_lts_add _A2 (linorder_prod _C _C) ra
                                      (fst pd) (snd pba) (fst (snd pab)),
                                     snd pd :: snd (snd pab))))
                          else pab))
                      (fst pc, (fst (snd (snd pc)), []))
                    in
                   ((fst pab,
                      (ins_dj_rm_basic_ops _A2 ra (fst (snd pc)),
                        (fst (snd pab),
                          (fst (snd (snd (snd pc))),
                            (if memb_rm_basic_ops (linorder_prod _A2 _A2) qa
                                  (nfa_acceptingp aA2)
                              then ins_dj_rm_basic_ops _A2 ra
                                     (snd (snd (snd (snd pc))))
                              else snd (snd (snd (snd pc)))))))),
                     snd (snd pab))))))
      ((fst pb,
         (empty_rm_basic_ops _A2 (),
           (rs_lts_empty _A2 (linorder_prod _C _C),
             (snd pb, empty_rm_basic_ops _A2 ())))),
        (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
                  (g_inter_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
                    (nfa_initialp nA1) (nfa_acceptingp nA1)))
          then g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
                 (nfa_initialp nA1) @
                 g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
                   (nfa_initialp aA2)
          else g_to_list_dflt_basic_oops_rm_basic_ops (linorder_prod _A2 _A2)
                 (nfa_initialp nA1)))
    in
   snd (fst pc)))))
                       then ins_dj_rm_basic_ops _A2 r (snd (snd (snd (snd pa))))
                       else snd (snd (snd (snd pa)))))))),
              snd (snd paa))))))
                                       ((fst p,
  (empty_rm_basic_ops _A2 (),
    (rs_lts_empty _A2 (linorder_prod _C _C),
      (snd p, empty_rm_basic_ops _A2 ())))),
 product (g_to_list_dflt_basic_oops_rm_basic_ops _A2 (fst (snd (snd sigmaa))))
   (g_to_list_dflt_basic_oops_rm_basic_ops _A2
     (fst (snd (snd (let nA1 =
                       rename_states_impl
                         (fun f s ->
                           iteratei_set_op_list_it_rs_ops _A2 s (fun _ -> true)
                             (fun ba ->
                               ins_rm_basic_ops (linorder_prod _A2 _A2) (f ba))
                             (empty_rm_basic_ops (linorder_prod _A2 _A2) ()))
                         (rs_lts_image _A2 (linorder_prod _C _C)
                           (linorder_prod _A2 _A2) (linorder_prod _C _C))
                         (the (lookup _B sigma (fst xc))) (fun a -> (rm, a))
                       in
                     let aA2 =
                       rename_states_impl
                         (fun f s ->
                           iteratei_set_op_list_it_rs_ops _A2 s (fun _ -> true)
                             (fun ba ->
                               ins_rm_basic_ops (linorder_prod _A2 _A2) (f ba))
                             (empty_rm_basic_ops (linorder_prod _A2 _A2) ()))
                         (rs_lts_image _A2 (linorder_prod _C _C)
                           (linorder_prod _A2 _A2) (linorder_prod _C _C))
                         (the (lookup _B sigma (snd xc))) (fun a -> (b, a))
                       in
                     let pa =
                       foldl (fun pa q ->
                               ((insert (linorder_prod _A2 _A2) (id q)
                                   (states_enumerate _A1 (snd (fst pa)))
                                   (fst (fst pa)),
                                  suc (snd (fst pa))),
                                 ins_dj_rm_basic_ops _A2
                                   (states_enumerate _A1 (snd (fst pa)))
                                   (snd pa)))
                         ((empty (linorder_prod _A2 _A2), zero_nat),
                           empty_rm_basic_ops _A2 ())
                         (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops
                                   (linorder_prod _A2 _A2)
                                   (g_inter_dflt_basic_oops_rm_basic_ops
                                     (linorder_prod _A2 _A2) (nfa_initialp nA1)
                                     (nfa_acceptingp nA1)))
                           then g_to_list_dflt_basic_oops_rm_basic_ops
                                  (linorder_prod _A2 _A2) (nfa_initialp nA1) @
                                  g_to_list_dflt_basic_oops_rm_basic_ops
                                    (linorder_prod _A2 _A2) (nfa_initialp aA2)
                           else g_to_list_dflt_basic_oops_rm_basic_ops
                                  (linorder_prod _A2 _A2) (nfa_initialp nA1))
                       in
                     let pb =
                       worklist (fun _ -> true)
                         (fun pb q ->
                           (let r =
                              the (lookup (linorder_prod _A2 _A2) (fst (fst pb))
                                    (id q))
                              in
                             (if memb_rm_basic_ops _A2 r (fst (snd pb))
                               then (pb, [])
                               else (let paa =
                                       tri_union_iterator
 (rs_lts_succ_label_it (linorder_prod _A2 _A2) (linorder_prod _C _C)
   (nfa_transp nA1))
 (rs_lts_succ_label_it (linorder_prod _A2 _A2) (linorder_prod _C _C)
   (nfa_transp aA2))
 (rs_lts_connect_it (linorder_prod _A2 _A2) (linorder_prod _C _C)
   (linorder_prod _A2 _A2) (nfa_transp nA1) (nfa_acceptingp nA1)
   (nfa_initialp aA2))
 q (fun _ -> true)
 (fun pc paa ->
   (if nempI _C.order_linorder.preorder_order.ord_preorder (fst pc)
     then (let r_opt =
             lookup (linorder_prod _A2 _A2) (fst (fst paa)) (id (snd pc)) in
           let pba =
             (if is_none r_opt
               then (let ra = states_enumerate _A1 (snd (fst paa)) in
                      ((insert (linorder_prod _A2 _A2) (id (snd pc)) ra
                          (fst (fst paa)),
                         suc (snd (fst paa))),
                        ra))
               else (fst paa, the r_opt))
             in
            (fst pba,
              (rs_lts_add _A2 (linorder_prod _C _C) r (fst pc) (snd pba)
                 (fst (snd paa)),
                snd pc :: snd (snd paa))))
     else paa))
 (fst pb, (fst (snd (snd pb)), []))
                                       in
                                      ((fst paa,
 (ins_dj_rm_basic_ops _A2 r (fst (snd pb)),
   (fst (snd paa),
     (fst (snd (snd (snd pb))),
       (if memb_rm_basic_ops (linorder_prod _A2 _A2) q (nfa_acceptingp aA2)
         then ins_dj_rm_basic_ops _A2 r (snd (snd (snd (snd pb))))
         else snd (snd (snd (snd pb)))))))),
snd (snd paa))))))
                         ((fst pa,
                            (empty_rm_basic_ops _A2 (),
                              (rs_lts_empty _A2 (linorder_prod _C _C),
                                (snd pa, empty_rm_basic_ops _A2 ())))),
                           (if not (g_isEmpty_dflt_basic_oops_rm_basic_ops
                                     (linorder_prod _A2 _A2)
                                     (g_inter_dflt_basic_oops_rm_basic_ops
                                       (linorder_prod _A2 _A2)
                                       (nfa_initialp nA1) (nfa_acceptingp nA1)))
                             then g_to_list_dflt_basic_oops_rm_basic_ops
                                    (linorder_prod _A2 _A2) (nfa_initialp nA1) @
                                    g_to_list_dflt_basic_oops_rm_basic_ops
                                      (linorder_prod _A2 _A2) (nfa_initialp aA2)
                             else g_to_list_dflt_basic_oops_rm_basic_ops
                                    (linorder_prod _A2 _A2) (nfa_initialp nA1)))
                       in
                      snd (fst pb)))))))
                                     in
                                    snd (fst pa)))
                                (the (lookup _B sigma xb))
                              in
                             insert _B xb xc sigma)
                      else sigma))
                  (fst (snd x))
                in
               (g_diff_dflt_basic_oops_rm_basic_ops _B (fst x) xa,
                 (xb, g_union_dflt_basic_oops_rm_basic_ops _B (snd (snd x))
                        xa))))
           (si, (rma, empty_rm_basic_ops _B ())));;

let rec rs_gen_rc_from_list _A
  l = foldl (fun m a ->
              insert _A (fst a)
                (foldl (fun s aa -> ins_rm_basic_ops (linorder_prod _A _A) aa s)
                  (empty_rm_basic_ops (linorder_prod _A _A) ()) (snd a))
                m)
        (empty _A) l;;

let rec rs_gen_rm_from_list _A (_B1, _B2) _C
  l = foldl (fun m a -> insert _A (fst a) (snd a) m) (empty _A) l;;

end;; (*struct Automata_lib*)
