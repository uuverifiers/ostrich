(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /Content-Disposition\u{3a}\u{20}inline\u{3b}[^\u{0d}\u{0a}]filename=[a-z]{5,8}\d{2,3}\.pdf\u{0d}\u{0a}/Hm
(assert (str.in_re X (re.++ (str.to_re "/Content-Disposition: inline;") (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".pdf\u{0d}\u{0a}/Hm\u{0a}"))))
; /^\d+O\d+\.jsp\?[a-z0-9\u{3d}\u{2b}\u{2f}]{20}/iR
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iR\u{0a}"))))
; ^[a-zA-Z][a-zA-Z\-' ]*[a-zA-Z ]$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "-") (str.to_re "'") (str.to_re " "))) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re " ")) (str.to_re "\u{0a}"))))
; \x2Fbar_pl\x2Fshdoclc\.fcgisource%3Dultrasearch136%26campaign%3DsnapEIHBand,
(assert (not (str.in_re X (str.to_re "/bar_pl/shdoclc.fcgisource%3Dultrasearch136%26campaign%3DsnapEIHBand,\u{0a}"))))
; this\s+MyBrowser\d+Redirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "this") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MyBrowser") (re.+ (re.range "0" "9")) (str.to_re "Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
