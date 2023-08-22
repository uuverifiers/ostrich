(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (([a-z']?[a-z' ]*)|([a-z][\.])?([a-z][\.]))
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (re.union (re.range "a" "z") (str.to_re "'"))) (re.* (re.union (re.range "a" "z") (str.to_re "'") (str.to_re " ")))) (re.++ (re.opt (re.++ (re.range "a" "z") (str.to_re "."))) (re.range "a" "z") (str.to_re "."))) (str.to_re "\u{0a}")))))
; /^POST\u{20}\u{2f}g[ao]lfstream\u{26}/
(assert (str.in_re X (re.++ (str.to_re "/POST /g") (re.union (str.to_re "a") (str.to_re "o")) (str.to_re "lfstream&/\u{0a}"))))
; /^\/[\w-]{48}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/U\u{0a}")))))
; devSoft\u{27}s\s+Host\x3AHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "devSoft's\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
