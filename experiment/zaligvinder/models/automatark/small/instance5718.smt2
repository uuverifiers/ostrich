(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 3AUser-Agent\x3AFROM\x3ARemoteqlqqlbojvii\u{2f}gtHost\x3A
(assert (not (str.in_re X (str.to_re "3AUser-Agent:FROM:Remoteqlqqlbojvii/gtHost:\u{0a}"))))
; YAHOODesktopHost\u{3a}LOGHost\x3AtvshowticketsResultsFROM\x3A
(assert (not (str.in_re X (str.to_re "YAHOODesktopHost:LOGHost:tvshowticketsResultsFROM:\u{0a}"))))
; Host\x3AHost\x3AUser-Agent\x3AServerad\x2Emokead\x2Ecom
(assert (not (str.in_re X (str.to_re "Host:Host:User-Agent:Serverad.mokead.com\u{0a}"))))
; ^(www\.regxlib\.com)$
(assert (not (str.in_re X (str.to_re "www.regxlib.com\u{0a}"))))
; ([1-9]{1,2})?(d|D)([1-9]{1,3})((\+|-)([1-9]{1,3}))?
(assert (not (str.in_re X (re.++ (re.opt ((_ re.loop 1 2) (re.range "1" "9"))) (re.union (str.to_re "d") (str.to_re "D")) ((_ re.loop 1 3) (re.range "1" "9")) (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "-")) ((_ re.loop 1 3) (re.range "1" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
