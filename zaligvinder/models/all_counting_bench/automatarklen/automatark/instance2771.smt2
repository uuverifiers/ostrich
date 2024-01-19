(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}smil([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.smil") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^([\s\S]){1,20}([\s\.])
(assert (str.in_re X (re.++ ((_ re.loop 1 20) (re.union (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
; CUSTOM\swww\x2Elocators\x2Ecom\d+Seconds\-
(assert (str.in_re X (re.++ (str.to_re "CUSTOM") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.locators.com") (re.+ (re.range "0" "9")) (str.to_re "Seconds-\u{0a}"))))
; User-Agent\x3A\x2Ftba\x2FFrom\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:/tba/From:\u{0a}"))))
; /\/flash201(3|4)\.php$/U
(assert (str.in_re X (re.++ (str.to_re "//flash201") (re.union (str.to_re "3") (str.to_re "4")) (str.to_re ".php/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
