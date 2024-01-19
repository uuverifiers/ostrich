(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; url=Referer\x3AHost\x3AWelcome\x2FcommunicatortbGateCrasher4\u{2e}8\u{2e}4\x7D\x7BTrojan\x3AareSubject\u{3a}
(assert (not (str.in_re X (str.to_re "url=Referer:Host:Welcome/communicatortbGateCrasher4.8.4}{Trojan:areSubject:\u{0a}"))))
; /\/pte\.aspx\?ver=\d\.\d\.\d+\.\d\u{26}rnd=\d{5}/Ui
(assert (str.in_re X (re.++ (str.to_re "//pte.aspx?ver=") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (str.to_re "&rnd=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; (([2-9]{1})([0-9]{2})([0-9]{3})([0-9]{4}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))))
; Supreme\d+Host\x3A\d+yxegtd\u{2f}efcwgHost\x3ATPSystem
(assert (str.in_re X (re.++ (str.to_re "Supreme") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "yxegtd/efcwgHost:TPSystem\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
