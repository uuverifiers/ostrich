(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+\x2Ftoolbar\x2Fico\x2F\dencoderserverreport\<\x2Ftitle\>
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/ico/") (re.range "0" "9") (str.to_re "encoderserverreport</title>\u{0a}"))))
; URL\s+url=Host\u{3a}httpUser-Agent\x3ASubject\x3A
(assert (str.in_re X (re.++ (str.to_re "URL") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "url=Host:httpUser-Agent:Subject:\u{0a}"))))
; Subject\x3AEnTrYExplorer\x2APORT2\x2AHost\x3A
(assert (not (str.in_re X (str.to_re "Subject:EnTrYExplorer*PORT2*Host:\u{0a}"))))
; ^(\+|-)?(\d\.\d{1,6}|[1-9]\d\.\d{1,6}|1[1-7]\d\.\d{1,6}|180\.0{1,6})$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.++ (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.range "1" "7") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (str.to_re "180.") ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}"))))
(check-sat)
