(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; DownloadDmInf\x5EinfoSimpsonUser-Agent\x3AClient
(assert (not (str.in_re X (str.to_re "DownloadDmInf^infoSimpsonUser-Agent:Client\u{0a}"))))
; action\x2EpioletHost\x3AIP-www\x2Einternetadvertisingcompany\x2Ebiz
(assert (not (str.in_re X (str.to_re "action.pioletHost:IP-www.internetadvertisingcompany.biz\u{0a}"))))
; (LT-?)?([0-9]{9}|[0-9]{12})
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "LT") (re.opt (str.to_re "-")))) (re.union ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 12 12) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; EFError.*Host\x3A\swww\u{2e}malware-stopper\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "EFError") (re.* re.allchar) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.malware-stopper.com\u{0a}")))))
; (@\s*".*?")|("([^"\\]|\\.)*?")
(assert (not (str.in_re X (re.union (re.++ (str.to_re "@") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.* re.allchar) (str.to_re "\u{22}")) (re.++ (str.to_re "\u{0a}\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (str.to_re "\u{22}"))))))
(check-sat)
