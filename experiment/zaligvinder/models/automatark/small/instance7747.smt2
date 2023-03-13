(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+]\d{2}?[- .]?(\([2-9]\d{2}\)|[2-9]\d{2})[- .]?\d{3}[- .]?\d{4}$
(assert (str.in_re X (re.++ (str.to_re "+") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) (re.union (re.++ (str.to_re "(") (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")")) (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3A\s+\.ico\x2FsLogearch195\.225\.Referer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".ico/sLogearch195.225.Referer:\u{0a}")))))
; (^\(\)$|^\(((\([0-9]+,(\((\([0-9]+,[0-9]+,[0-9]+\),)*(\([0-9]+,[0-9]+,[0-9]+\)){1}\))+\),)*(\([0-9]+,(\((\([0-9]+,[0-9]+,[0-9]+\),)*(\([0-9]+,[0-9]+,[0-9]+\)){1}\))+\)){1}\)))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}(") (re.union (str.to_re ")") (re.++ (re.* (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.++ (str.to_re "(") (re.* (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re "),"))) ((_ re.loop 1 1) (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ")"))) (str.to_re ")"))) (str.to_re "),"))) ((_ re.loop 1 1) (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.++ (str.to_re "(") (re.* (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re "),"))) ((_ re.loop 1 1) (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ")"))) (str.to_re ")"))) (str.to_re ")"))) (str.to_re ")"))))))
; www\x2Epurityscan\x2Ecom.*
(assert (not (str.in_re X (re.++ (str.to_re "www.purityscan.com") (re.* re.allchar) (str.to_re "\u{0a}")))))
(check-sat)
