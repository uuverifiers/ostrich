(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-hA-H]{1}[1-8]{1})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.range "a" "h") (re.range "A" "H"))) ((_ re.loop 1 1) (re.range "1" "8")))))
; Referer\x3A\s+HXDownload\w+installs\x2Eseekmo\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HXDownload") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "installs.seekmo.com\u{0a}"))))
; ^[A-Za-z]{2}[ ]{0,1}[0-9]{2}[ ]{0,1}[a-zA-Z]{3}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; /^h=\d+&w=\d+&ua=/Psi
(assert (not (str.in_re X (re.++ (str.to_re "/h=") (re.+ (re.range "0" "9")) (str.to_re "&w=") (re.+ (re.range "0" "9")) (str.to_re "&ua=/Psi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
