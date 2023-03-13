(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ProjectMyWebSearchSearchAssistantfast-look\x2EcomOneReporter
(assert (str.in_re X (str.to_re "ProjectMyWebSearchSearchAssistantfast-look.comOneReporter\u{0a}")))
; User-Agent\x3Aetbuviaebe\u{2f}eqv\.bvv
(assert (not (str.in_re X (str.to_re "User-Agent:etbuviaebe/eqv.bvv\u{0a}"))))
; Agent.*as\x2Estarware\x2Ecom\s+ServerToolbarcojud\x2Edmcast\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Agent") (re.* re.allchar) (str.to_re "as.starware.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ServerToolbarcojud.dmcast.com\u{0a}"))))
; ^(0|[-]{1}([1-9]{1}[0-9]{0,1}|[1]{1}([0-1]{1}[0-9]{1}|[2]{1}[0-8]{1}))|(\+)?([1-9]{1}[0-9]{0,1}|[1]{1}([0-1]{1}[0-9]{1}|[2]{1}[0-7]{1})))$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ ((_ re.loop 1 1) (str.to_re "-")) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.opt (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "1")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "2")) ((_ re.loop 1 1) (re.range "0" "8"))))))) (re.++ (re.opt (str.to_re "+")) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.opt (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "1")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "2")) ((_ re.loop 1 1) (re.range "0" "7")))))))) (str.to_re "\u{0a}")))))
(check-sat)
