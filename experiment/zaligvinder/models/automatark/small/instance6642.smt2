(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^SSID=[a-zA-Z\d]{43}\x3B\u{20}A=[0-3]$/C
(assert (not (str.in_re X (re.++ (str.to_re "/SSID=") ((_ re.loop 43 43) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "; A=") (re.range "0" "3") (str.to_re "/C\u{0a}")))))
; port\s+aresflashdownloader\x2Ecom\s+adfsgecoiwnf\u{23}\u{23}\u{23}\u{23}User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "port") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "aresflashdownloader.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}####User-Agent:\u{0a}")))))
; /filename=[^\n]*\u{2e}pdf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pdf/i\u{0a}"))))
(check-sat)
