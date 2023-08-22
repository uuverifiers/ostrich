(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; EvilFTP\s+%3f[^\n\r]*\.bmpfilename\x3D\u{22}
(assert (str.in_re X (re.++ (str.to_re "EvilFTP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "%3f") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re ".bmpfilename=\u{22}\u{0a}"))))
; /\/jovf\.html$/U
(assert (not (str.in_re X (str.to_re "//jovf.html/U\u{0a}"))))
; /\/[a-z0-9]{12}\.txt$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 12 12) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".txt/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
