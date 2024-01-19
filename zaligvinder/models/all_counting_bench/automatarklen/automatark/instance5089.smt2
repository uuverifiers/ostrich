(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]{0,1})([0-9]{1})((\.[0-9]{0,1})([0-9]{1})|(\,[0-9]{0,1})([0-9]{1}))?$
(assert (str.in_re X (re.++ (re.opt (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ".") (re.opt (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",") (re.opt (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; ^(\(\d{3}\)[- ]?|\d{3}[- ])?\d{3}[- ]\d{4}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (re.union (str.to_re "-") (str.to_re " ")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " "))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ShadowNet\dsearchresltAID\x2FUser-Agent\x3AFen\u{ea}treEye\x2Fdss\x2Fcc\.2_0_0\.
(assert (not (str.in_re X (re.++ (str.to_re "ShadowNet") (re.range "0" "9") (str.to_re "searchresltAID/User-Agent:Fen\u{ea}treEye/dss/cc.2_0_0.\u{0a}")))))
; /\u{2e}wmf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.wmf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
