(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-9]{3})[-]?)*[0-9]{6,7}$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")))) ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; zopabora\x2EinfocomhoroscopeTravelInsidefromUser-Agent\x3AFrom\x3Awww\x2EZSearchResults\x2EcomExplorer
(assert (str.in_re X (str.to_re "zopabora.infocomhoroscopeTravelInsidefromUser-Agent:From:www.ZSearchResults.com\u{13}Explorer\u{0a}")))
; /\u{2e}pac([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pac") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; \x2Fcbn\x2F\s+Host\x3Abinde2give\.com
(assert (not (str.in_re X (re.++ (str.to_re "/cbn/") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:binde2give.com\u{0a}")))))
; ^[a-zA-Z]+(([\'\,\.\-][a-zA-Z])?[a-zA-Z]*)*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.opt (re.++ (re.union (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "-")) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
(check-sat)
