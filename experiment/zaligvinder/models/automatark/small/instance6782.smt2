(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \D
(assert (not (str.in_re X (re.++ (re.comp (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Login\sHost\x3A\w+Host\u{3a}iz=iMeshBar%3f\x2Fbar_pl\x2Fchk_bar\.fcgi
(assert (str.in_re X (re.++ (str.to_re "Login") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:iz=iMeshBar%3f/bar_pl/chk_bar.fcgi\u{0a}"))))
; ^[\d]{4}[-\s]{1}[\d]{3}[-\s]{1}[\d]{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
