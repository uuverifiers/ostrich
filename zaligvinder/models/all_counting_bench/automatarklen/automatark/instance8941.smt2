(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}kvl/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".kvl/i\u{0a}"))))
; @"^\d[a-zA-Z]\w{1}\d{2}[a-zA-Z]\w{1}\d{3}$"
(assert (not (str.in_re X (re.++ (str.to_re "@\u{22}") (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{22}\u{0a}")))))
; this\s+MyBrowser\d+Redirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "this") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MyBrowser") (re.+ (re.range "0" "9")) (str.to_re "Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}")))))
; <script[\\.|\\W|\\w]*?</script>
(assert (not (str.in_re X (re.++ (str.to_re "<script") (re.* (re.union (str.to_re "\u{5c}") (str.to_re ".") (str.to_re "|") (str.to_re "W") (str.to_re "w"))) (str.to_re "</script>\u{0a}")))))
; \x2Fbar_pl\x2Fshdoclc\.fcgisource%3Dultrasearch136%26campaign%3DsnapEIHBand,
(assert (str.in_re X (str.to_re "/bar_pl/shdoclc.fcgisource%3Dultrasearch136%26campaign%3DsnapEIHBand,\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
