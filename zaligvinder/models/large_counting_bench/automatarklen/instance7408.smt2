(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[a-z\d\u{2b}\u{2f}\u{3d}]{48,256}$/iP
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 48 256) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/") (str.to_re "="))) (str.to_re "/iP\u{0a}"))))
; \/cgi-bin\/PopupVHost\x3Apiolet\x0D\x0A\x0D\x0AAttached
(assert (str.in_re X (str.to_re "/cgi-bin/PopupVHost:piolet\u{0d}\u{0a}\u{0d}\u{0a}Attached\u{0a}")))
; ^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.++ (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
