(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]{4}\d{7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; [0-9A-Fa-f]{2}(\.?)[0-9A-Fa-f]{2}(\.?)[0-9A-Fa-f]{2}(\.?)[0-9A-Fa-f]{2}
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (re.opt (str.to_re ".")) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (re.opt (str.to_re ".")) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (re.opt (str.to_re ".")) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re "\u{0a}"))))
(check-sat)
