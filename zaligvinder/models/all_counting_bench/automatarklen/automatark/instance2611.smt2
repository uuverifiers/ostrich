(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2FrssScaneradfsgecoiwnf\x7D\x7BTrojan\x3AlogsHost\u{3a}
(assert (str.in_re X (str.to_re "/rssScaneradfsgecoiwnf\u{1b}}{Trojan:logsHost:\u{0a}")))
; Host\x3A\s+Online\s+ocllceclbhs\u{2f}gth
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Online") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ocllceclbhs/gth\u{0a}")))))
; ^(([-\w$%&'*+\/=?^_`{|}~.]+)@(([-a-zA-Z0-9_]+\.)*)([-a-zA-Z0-9]+\.)([a-zA-Z0-9]{2,7}))?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.+ (re.union (str.to_re "-") (str.to_re "$") (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "/") (str.to_re "=") (str.to_re "?") (str.to_re "^") (str.to_re "_") (str.to_re "`") (str.to_re "{") (str.to_re "|") (str.to_re "}") (str.to_re "~") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.* (re.++ (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "."))) ((_ re.loop 2 7) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "."))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
