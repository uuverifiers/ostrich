(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}ram/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ram/i\u{0a}")))))
; JMailReportgpstool\u{2e}globaladserver\u{2e}com
(assert (str.in_re X (str.to_re "JMailReportgpstool.globaladserver.com\u{0a}")))
; ([+(]?\d{0,2}[)]?)([-/.\s]?\d+)+
(assert (str.in_re X (re.++ (re.+ (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "/") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "+") (str.to_re "("))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (str.to_re ")")))))
; ToolBar\s+HWAEUser-Agent\x3ATheef2-\>M\x2Ezipbar\-navig\x2Eyandex\x2Eru
(assert (not (str.in_re X (re.++ (str.to_re "ToolBar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HWAEUser-Agent:Theef2->M.zipbar-navig.yandex.ru\u{0a}")))))
(check-sat)
