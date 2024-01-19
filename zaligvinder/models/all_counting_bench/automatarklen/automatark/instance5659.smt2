(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (((ht|f)tp(s?))\://)?(\bw{3}[^w]\b)?[^w{4}][^\@]([0-9a-zA-Z\-]+\.)+[a-zA-Z]{2,6}(\:[0-9]+)?(/\S*)?
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "://") (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")))) (re.opt (re.++ ((_ re.loop 3 3) (str.to_re "w")) (re.comp (str.to_re "w")))) (re.union (str.to_re "w") (str.to_re "{") (str.to_re "4") (str.to_re "}")) (re.comp (str.to_re "@")) (re.+ (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "-"))) (str.to_re "."))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) (str.to_re "\u{0a}")))))
; /\u{2e}ppsx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ppsx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
