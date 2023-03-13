(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\x2F40e800[0-9A-F]{30,}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//40e800/Ui\u{0a}") ((_ re.loop 30 30) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F")))))))
; \x7D\x7BPassword\x3ADesktopDownloadfowclxccdxn\u{2f}uxwn\.ddy
(assert (str.in_re X (str.to_re "}{Password:\u{1b}DesktopDownloadfowclxccdxn/uxwn.ddy\u{0a}")))
(check-sat)
