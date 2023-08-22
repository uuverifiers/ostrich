(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (-?(\d*\.\d{1}?\d*|\d{1,}))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (re.union (re.++ (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.+ (re.range "0" "9")))))))
; Referer\x3A\s+HXDownload.*Referer\x3AGREATDripline
(assert (not (str.in_re X (re.++ (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HXDownload") (re.* re.allchar) (str.to_re "Referer:GREATDripline\u{0a}")))))
; Software\s+User-Agent\x3A.*FictionalUser-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Software") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "FictionalUser-Agent:User-Agent:\u{0a}")))))
; fsbuffsearch\u{2e}conduit\u{2e}comocllceclbhs\u{2f}gth
(assert (str.in_re X (str.to_re "fsbuffsearch.conduit.comocllceclbhs/gth\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
