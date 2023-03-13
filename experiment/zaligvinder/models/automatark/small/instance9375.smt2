(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]|[1-9]\d|100)$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (str.to_re "100")) (str.to_re "\u{0a}"))))
; url=http\x3AGamespyjspIDENTIFYserverHOST\x3ASubject\x3A
(assert (not (str.in_re X (str.to_re "url=http:\u{1b}GamespyjspIDENTIFYserverHOST:Subject:\u{0a}"))))
; (W(5|6)[D]?\-\d{9})|(W1\-\d{9}(\-\d{2})?)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "W") (re.union (str.to_re "5") (str.to_re "6")) (re.opt (str.to_re "D")) (str.to_re "-") ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}W1-") ((_ re.loop 9 9) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))))))))
; Logs.*with\x3A\s+OnlineServer\u{3a}Yeah\!
(assert (not (str.in_re X (re.++ (str.to_re "Logs") (re.* re.allchar) (str.to_re "with:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OnlineServer:Yeah!\u{0a}")))))
(check-sat)
