(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+]?100(\.0{1,2})?%?$|^[+]?\d{1,2}(\.\d{1,2})?%?$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "+")) (str.to_re "100") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0")))) (re.opt (str.to_re "%"))) (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; for[^\n\r]*Host\x3A\sinternalcyber@yahoo\x2EcomHeadersRedirection
(assert (not (str.in_re X (re.++ (str.to_re "for") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "internalcyber@yahoo.comHeadersRedirection\u{0a}")))))
; Port\x2E[^\n\r]*007\d+Logsdl\x2Eweb-nexus\x2Enet
(assert (str.in_re X (re.++ (str.to_re "Port.") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "007") (re.+ (re.range "0" "9")) (str.to_re "Logsdl.web-nexus.net\u{0a}"))))
; User-Agent\x3A\d+Desktop\sIDENTIFY666User-Agent\x3A\x5BStatic
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "Desktop") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "IDENTIFY666User-Agent:[Static\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
