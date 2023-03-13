(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}wmx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wmx/i\u{0a}"))))
; are\s+Toolbar\s+X-Mailer\x3AInformationsearchnuggetspastb\x2Efreeprod\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "are") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}Informationsearchnugget\u{13}spastb.freeprod.com\u{0a}")))))
; Keylogger\w+Owner\x3A\dBetaWordixqshv\u{2f}qzccsServer\u{00}MyBYReferer\x3Awww\x2Eccnnlc\x2Ecom\u{04}\u{00}
(assert (not (str.in_re X (re.++ (str.to_re "Keylogger") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.range "0" "9") (str.to_re "BetaWordixqshv/qzccsServer\u{00}MyBYReferer:www.ccnnlc.com\u{13}\u{04}\u{00}\u{0a}")))))
; \b[A-Z-[DFIOQUWZ]]\d[A-Z-[DFIOQU]]\ +\d[A-Z-[DFIOQU]]\d\b
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (str.to_re "-") (str.to_re "[") (str.to_re "D") (str.to_re "F") (str.to_re "I") (str.to_re "O") (str.to_re "Q") (str.to_re "U") (str.to_re "W") (str.to_re "Z")) (str.to_re "]") (re.range "0" "9") (re.union (re.range "A" "Z") (str.to_re "-") (str.to_re "[") (str.to_re "D") (str.to_re "F") (str.to_re "I") (str.to_re "O") (str.to_re "Q") (str.to_re "U")) (str.to_re "]") (re.+ (str.to_re " ")) (re.range "0" "9") (re.union (re.range "A" "Z") (str.to_re "-") (str.to_re "[") (str.to_re "D") (str.to_re "F") (str.to_re "I") (str.to_re "O") (str.to_re "Q") (str.to_re "U")) (str.to_re "]") (re.range "0" "9") (str.to_re "\u{0a}"))))
; /\/[a-f0-9]{32}\.jar/
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".jar/\u{0a}"))))
(check-sat)
