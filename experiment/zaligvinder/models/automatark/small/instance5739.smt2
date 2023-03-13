(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SPY\s\x5BStaticHost\x3AFROM\x3Acs\x2Eshopperreports\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "SPY") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "[StaticHost:FROM:cs.shopperreports.com\u{0a}")))))
; /\u{2e}jmh([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jmh") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /filename\=[a-z0-9]{24}\.exe/H
(assert (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".exe/H\u{0a}"))))
; User-Agent\x3AHost\x3ATeomaBarHost\x3AHoursHost\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:Host:TeomaBarHost:HoursHost:\u{0a}"))))
; /\u{2e}smil([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.smil") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(check-sat)
