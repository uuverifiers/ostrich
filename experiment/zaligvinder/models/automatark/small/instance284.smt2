(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AtoUser-Agent\x3AClientsConnected-
(assert (not (str.in_re X (str.to_re "Host:toUser-Agent:ClientsConnected-\u{0a}"))))
; From\u{3a}X-Mailer\x3Abacktrust\x2EcomReferer\u{3a}Supremewjpropqmlpohj\u{2f}loLogsX-FILTERED-BY-GHOST\u{3a}
(assert (str.in_re X (str.to_re "From:X-Mailer:\u{13}backtrust.comReferer:Supremewjpropqmlpohj/loLogsX-FILTERED-BY-GHOST:\u{0a}")))
; ^-?([1]?[1-7][1-9]|[1]?[1-8][0]|[1-9]?[0-9])\.{1}\d{1,6}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (str.to_re "1")) (re.range "1" "7") (re.range "1" "9")) (re.++ (re.opt (str.to_re "1")) (re.range "1" "8") (str.to_re "0")) (re.++ (re.opt (re.range "1" "9")) (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; log\=\x7BIP\x3A\s+Pcast\d+Host\u{3a}ohgdhkzfhdzo\u{2f}uwpOK\r\nHost\x3AHWAEname\u{2e}cnnic\u{2e}cnRXnewads1\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "log={IP:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Pcast") (re.+ (re.range "0" "9")) (str.to_re "Host:ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}Host:HWAEname.cnnic.cnRXnewads1.com\u{0a}")))))
(check-sat)
