(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /nim:import\?[^\u{22}\u{27}>\s]*?filename=[^\u{22}\u{27}>\s]{485}/i
(assert (not (str.in_re X (re.++ (str.to_re "/nim:import?") (re.* (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "filename=") ((_ re.loop 485 485) (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/i\u{0a}")))))
; ((([7-9])(\d{3})([-])(\d{4}))|(([7-9])(\d{7})))
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "7" "9") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "7" "9") ((_ re.loop 7 7) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^([a-zA-z\s]{4,32})$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 32) (re.union (re.range "a" "z") (re.range "A" "z") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; /^number=[0-9A-F]{32}$/mC
(assert (not (str.in_re X (re.++ (str.to_re "/number=") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/mC\u{0a}")))))
; ^\d+(\.\d{2})?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
