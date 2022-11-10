//
//  WorkoutMenuViewModel.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/02.
//

import Foundation
import RealmSwift

class WorkoutMenuViewModel {
    
    var workoutMenuArray: [WorkoutMenu] = []

    init() {
        
        let chestDic: [String: Any] = ["targetPart": "大胸筋",
                                       "workoutNames": [["workoutName": "ベンチプレス"],
                                                        ["workoutName": "インクラインベンチプレス"],
                                                        ["workoutName": "デクラインベンチプレス"],
                                                        ["workoutName": "ディップス"],
                                                        ["workoutName": "ダンベルプレス"],
                                                        ["workoutName": "ダンベルフライ"],
                                                        ["workoutName": "プルオーバー"]]]
        let chestMenu = WorkoutMenu(value: chestDic)
        workoutMenuArray.append(chestMenu)
        
        let latDic: [String: Any] = ["targetPart": "広背筋",
                                     "workoutNames": [["workoutName": "チンニング"],
                                                      ["workoutName": "ラットプルダウン"],
                                                      ["workoutName": "バーベルロウ"],
                                                      ["workoutName": "ワンハンドロウ"],
                                                      ["workoutName": "Tバーロウ"]]]
        let latMenu = WorkoutMenu(value: latDic)
        workoutMenuArray.append(latMenu)
        
        let backDic: [String: Any] = ["targetPart": "脊柱起立筋",
                                      "workoutNames": [["workoutName": "バックエクステンション"],
                                                       ["workoutName": "デッドリフト"],
                                                       ["workoutName": "グッドモーニング"]]]
        let backMenu = WorkoutMenu(value: backDic)
        workoutMenuArray.append(backMenu)
        
        let deltDic: [String: Any] = ["targetPart": "三角筋",
                                      "workoutNames": [["workoutName": "バーベルショルダーープレス"],
                                                       ["workoutName": "ダンベルショルダープレス"],
                                                       ["workoutName": "アップライトロウ"],
                                                       ["workoutName": "フロントレイズ"],
                                                       ["workoutName": "サイドレイズ"],
                                                       ["workoutName": "リアレイズ"],
                                                       ["workoutName": "ライイングサイドレイズ"],
                                                       ["workoutName": "ライイングリアレイズ"]]]
        let deltMenu = WorkoutMenu(value: deltDic)
        workoutMenuArray.append(deltMenu)
        
        let bicepsDic: [String: Any] = ["targetPart": "上腕二頭筋",
                                        "workoutNames": [["workoutName": "バーベルカール"],
                                                         ["workoutName": "プリーチャーカール"],
                                                         ["workoutName": "スピネイトカール"],
                                                         ["workoutName": "ハンマーカール"],
                                                         ["workoutName": "インクラインカール"],
                                                         ["workoutName": "コンセントレーションカール"],
                                                         ["workoutName": "ドラックカール"],
                                                         ["workoutName": "スパイダーカール"]]]
        let bicepsMenu = WorkoutMenu(value: bicepsDic)
        workoutMenuArray.append(bicepsMenu)
        
        let tricepsDic: [String: Any] = ["targetPart": "上腕三頭筋",
                                         "workoutNames": [["workoutName": "ナローベンチプレス"],
                                                          ["workoutName": "フレンチプレス"],
                                                          ["workoutName": "スカルクラッシャー"],
                                                          ["workoutName": "トライセプスキックバック"],
                                                          ["workoutName": "テイトプレス"],
                                                          ["workoutName": "ケーブルプレスダウン"]]]
        let tricepsMenu = WorkoutMenu(value: tricepsDic)
        workoutMenuArray.append(tricepsMenu)
        
        let forearmDic: [String: Any] = ["targetPart": "前腕筋群",
                                        "workoutNames": [["workoutName": "リバースカール"],
                                                         ["workoutName": "リストカール"],
                                                         ["workoutName": "リバースリストカール"],
                                                         ["workoutName": "ラディアルフレクション"],
                                                         ["workoutName": "ウルナフレクション"],
                                                         ["workoutName": "リストスピネーション"]]]
        let forearmMenu = WorkoutMenu(value: forearmDic)
        workoutMenuArray.append(forearmMenu)
        
        let quadsDic: [String: Any] = ["targetPart": "大腿四頭筋",
                                        "workoutNames": [["workoutName": "スクワット"],
                                                         ["workoutName": "シシースクワット"],
                                                         ["workoutName": "レッグエクステンション"]]]
        let quadsMenu = WorkoutMenu(value: quadsDic)
        workoutMenuArray.append(quadsMenu)
        
        let hamsDic: [String: Any] = ["targetPart": "ハムストリングス/大臀筋",
                                        "workoutNames": [["workoutName": "ルーマニアンデッドリフト"],
                                                         ["workoutName": "レッグカール"],
                                                         ["workoutName": "ブルガリアンスクワット"],
                                                         ["workoutName": "フロントランジ"],
                                                         ["workoutName": "リバースランジ"],
                                                         ["workoutName": "サイドランジ"],
                                                         ["workoutName": "ヒップリフト"],
                                                         ["workoutName": "グルートハムレイズ"]]]
        let hamsMenu = WorkoutMenu(value: hamsDic)
        workoutMenuArray.append(hamsMenu)
        
        let calfDic: [String: Any] = ["targetPart": "カーフ",
                                        "workoutNames": [["workoutName": "カーフレイズ"],
                                                         ["workoutName": "シーテッドカーフレイズ"]]]
        let calfMenu = WorkoutMenu(value: calfDic)
        workoutMenuArray.append(calfMenu)
        
        let absDic: [String: Any] = ["targetPart": "腹筋",
                                        "workoutNames": [["workoutName": "シットアップ"],
                                                         ["workoutName": "ツイストシットアップ"],
                                                         ["workoutName": "ケーブルクランチ"],
                                                         ["workoutName": "ハンギングレッグレイズ"],
                                                         ["workoutName": "ハンギングワイパー"],
                                                         ["workoutName": "サイドベント"],
                                                         ["workoutName": "アブローラー"]]]
        let absMenu = WorkoutMenu(value: absDic)
        workoutMenuArray.append(absMenu)
    }
}

//        workoutMenuArray.append(contentsOf: [
//            WorkoutMenu(targetPart: "大胸筋",
//                        workoutNames: [WorkoutName(workoutName: "ベンチプレス"),
//                                      WorkoutName(workoutName: "インクラインベンチプレス"),
//                                      WorkoutName(workoutName: "デクラインベンチプレス"),
//                                      WorkoutName(workoutName: "ディップス"),
//                                      WorkoutName(workoutName: "ダンベルプレス"),
//                                      WorkoutName(workoutName: "ダンベルフライ"),
//                                      WorkoutName(workoutName: "プルオーバー")
//                                     ]),
//            WorkoutMenu(targetPart: "広背筋",
//                        workoutNames: [WorkoutName(workoutName: "チンニング"),
//                                      WorkoutName(workoutName: "ラットプルダウン"),
//                                      WorkoutName(workoutName: "バーベルロウ"),
//                                      WorkoutName(workoutName: "ワンハンドロウ"),
//                                      WorkoutName(workoutName: "Tバーロウ")
//                                     ]),
//            WorkoutMenu(targetPart: "脊柱起立筋",
//                        workoutNames: [WorkoutName(workoutName: "バックエクステンション"),
//                                      WorkoutName(workoutName: "デッドリフト"),
//                                      WorkoutName(workoutName: "グッドモーニング")
//                                     ]),
//            WorkoutMenu(targetPart: "三角筋",
//                        workoutNames: [WorkoutName(workoutName: "バーベルショルダーープレス"),
//                                      WorkoutName(workoutName: "ダンベルショルダープレス"),
//                                      WorkoutName(workoutName: "アップライトロウ"),
//                                      WorkoutName(workoutName: "フロントレイズ"),
//                                      WorkoutName(workoutName: "サイドレイズ"),
//                                      WorkoutName(workoutName: "リアレイズ"),
//                                      WorkoutName(workoutName: "ライイングサイドレイズ"),
//                                      WorkoutName(workoutName: "ライイングリアレイズ")
//                                     ]),

//            WorkoutMenu(targetPart: "上腕二頭筋",
//                        workoutNames: [WorkoutName(workoutName: "バーベルカール"),
//                                      WorkoutName(workoutName: "プリーチャーカール"),
//                                      WorkoutName(workoutName: "スピネイトカール"),
//                                      WorkoutName(workoutName: "ハンマーカール"),
//                                      WorkoutName(workoutName: "インクラインカール"),
//                                      WorkoutName(workoutName: "コンセントレーションカール"),
//                                      WorkoutName(workoutName: "ドラックカール"),
//                                      WorkoutName(workoutName: "スパイダーカール")
//                                     ]),
//            WorkoutMenu(targetPart: "上腕三頭筋",
//                        workoutNames: [WorkoutName(workoutName: "ナローベンチプレス"),
//                                      WorkoutName(workoutName: "フレンチプレス"),
//                                      WorkoutName(workoutName: "スカルクラッシャー"),
//                                      WorkoutName(workoutName: "トライセプスキックバック"),
//                                      WorkoutName(workoutName: "テイトプレス"),
//                                      WorkoutName(workoutName: "ケーブルプレスダウン")
//                                     ]),
//            WorkoutMenu(targetPart: "前腕筋群",
//                        workoutNames: [WorkoutName(workoutName: "リバースカール"),
//                                      WorkoutName(workoutName: "リストカール"),
//                                      WorkoutName(workoutName: "リバースリストカール"),
//                                      WorkoutName(workoutName: "ラディアルフレクション"),
//                                      WorkoutName(workoutName: "ウルナフレクション"),
//                                      WorkoutName(workoutName: "リストスピネーション")
//                                     ]),
//            WorkoutMenu(targetPart: "大腿四頭筋",
//                        workoutNames: [WorkoutName(workoutName: "スクワット"),
//                                      WorkoutName(workoutName: "シシースクワット"),
//                                      WorkoutName(workoutName: "レッグエクステンション")
//                                     ]),
//            WorkoutMenu(targetPart: "ハムストリングス/大臀筋",
//                        workoutNames: [WorkoutName(workoutName: "ルーマニアンデッドリフト"),
//                                      WorkoutName(workoutName: "レッグカール"),
//                                      WorkoutName(workoutName: "ブルガリアンスクワット"),
//                                      WorkoutName(workoutName: "フロントランジ"),
//                                      WorkoutName(workoutName: "リバースランジ"),
//                                      WorkoutName(workoutName: "サイドランジ"),
//                                      WorkoutName(workoutName: "ヒップリフト"),
//                                      WorkoutName(workoutName: "グルートハムレイズ")
//                                     ]),
//            WorkoutMenu(targetPart: "カーフ",
//                        workoutNames: [WorkoutName(workoutName: "カーフレイズ"),
//                                      WorkoutName(workoutName: "シーテッドカーフレイズ")
//                                     ]),
//            WorkoutMenu(targetPart: "腹筋",
//                        workoutNames: [WorkoutName(workoutName: "シットアップ"),
//                                      WorkoutName(workoutName: "ツイストシットアップ"),
//                                      WorkoutName(workoutName: "ケーブルクランチ"),
//                                      WorkoutName(workoutName: "ハンギングレッグレイズ"),
//                                      WorkoutName(workoutName: "ハンギングワイパー"),
//                                      WorkoutName(workoutName: "サイドベント"),
//                                      WorkoutName(workoutName: "アブローラー")
//                                     ]),
//        ])
