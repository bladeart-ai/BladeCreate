/* eslint-disable @typescript-eslint/no-explicit-any */

export interface ModelSnapshot {
  modelUID: string
  versionUID: string
  modelName: string
  modelIntro: string
  createTime: string
  modelType: string
  baseModel: string
  source: string
  imageURLs: string[]
  civitaiURL: string | null
  trainingID: string | null
}

export interface ModelPreset {
  presetUID: string
  imageURL: string
  modelUID: string
  versionUID: string
  params: Map<string, string>
}

export interface ModelDetail {
  modelSnapshot: ModelSnapshot
  modelVersionUIDs: string[]
  modelPresets: ModelPreset[]
}

const modelSnapshots: Map<string, ModelSnapshot[]> = new Map([
  [
    '1',
    [
      {
        modelUID: '1',
        versionUID: 'V1',
        modelName: 'Fire Faerie - Neopets style fire fairy',
        modelIntro: 'This is a model intro',
        createTime: '2023',
        modelType: 'LoRA',
        baseModel: 'SD 1.5',
        source: 'training',
        imageURLs: [
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/4f188a52-c7a8-4f5a-83a7-838fd008b3fa/width=450/00103-3356206731.jpeg',
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/a5fefa92-3519-4693-8333-b4e648d306a7/width=450/00106-3356206734.jpeg',
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/41498aac-dc5a-4bb3-8479-3a1b076a6c98/width=450/00107-3977390011.jpeg',
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/53ad736f-d22c-48ba-9731-74a21ef6f77a/width=450/00108-3977390012.jpeg',
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/69885b7c-5f6b-4096-9e32-89646a3848f6/width=450/00110-3977390014.jpeg'
        ],
        civitaiURL: null,
        trainingID: '1'
      }
    ]
  ],
  [
    '2',
    [
      {
        modelUID: '2',
        versionUID: 'V1',
        modelName: 'Explosm Cyanide and Happiness style',
        modelIntro: 'This is a model intro',
        createTime: '2023',
        modelType: 'LoRA',
        baseModel: 'SD 1.5',
        source: 'civitai',
        imageURLs: [
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/673549b3-cbe2-4c52-9251-44500767268b/width=450/02976-3965852425-_lora_cah-10_1_%20cah,%20hatsune%20miku,%20masterpiece,%20best%20quality.jpeg'
        ],
        civitaiURL: 'https://civitai.com/models/134056/explosm-cyanide-and-happiness-style',
        trainingID: null
      }
    ]
  ],
  [
    '3',
    [
      {
        modelUID: '3',
        versionUID: 'latest',
        modelName: 'Galactic Empire Style - Stormtroopify anything!\n',
        modelIntro: 'This is a model intro',
        createTime: '2023',
        modelType: 'LoRA',
        baseModel: 'SD 1.5',
        source: 'civitai',
        imageURLs: [
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/fc3753df-14d8-4557-ac03-07228b0b1fa7/width=450/2023-09-09%20-%2000.40.39.jpeg'
        ],
        civitaiURL:
          'https://civitai.com/models/142415/galactic-empire-style-stormtroopify-anything',
        trainingID: null
      }
    ]
  ],
  [
    '4',
    [
      {
        modelUID: '4',
        versionUID: 'Polish Doll Likeness',
        modelName: 'Doll Likeness - by EDG\n',
        modelIntro: 'This is a model intro for latest version',
        createTime: '2023',
        modelType: 'LoRA',
        baseModel: 'SD 1.5',
        source: 'civitai',
        imageURLs: [
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/650db322-7410-4580-a571-2c714ea376a1/width=450/01920-1009220252-((Masterpiece,%20best%20quality,edgQuality)),smirk,smug,lipstick,_beautiful%20edgPL_woman,edgPL_face,edgPL_body,%20a%20woman%20with%20blonde%20h.jpeg'
        ],
        civitaiURL: 'https://civitai.com/models/42903/doll-likeness-by-edg',
        trainingID: null
      },
      {
        modelUID: '4',
        versionUID: 'Rubicon Doll Likeness',
        modelName: 'Doll Likeness - by EDG\n',
        modelIntro: 'This is a model intro for latest version',
        createTime: '2023',
        modelType: 'LoRA',
        baseModel: 'SD 1.5',
        source: 'civitai',
        imageURLs: [
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/e9cd3465-863b-48a6-92cc-8bdb4d291b7a/width=450/01587-2854178448-((Masterpiece,%20best%20quality,edgQuality)),smirk,smug,_edgAyre,%20red%20hair,red%20eyes,dress_%20_lora_edgAyre_AC6_1_.jpeg',
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/6c78e6d1-7ab6-4053-852f-0f5b131462a0/width=450/01589-1684788194-((Masterpiece,%20best%20quality,edgQuality)),smirk,smug,_edgAyre,%20red%20hair,red%20eyes,dress,_%20_lora_edgAyre_AC6_1__edgParure_jewelery,.jpeg'
        ],
        civitaiURL: 'https://civitai.com/models/42903?modelVersionId=156633',
        trainingID: null
      },
      {
        modelUID: '4',
        versionUID: 'Bulgarian Doll Likeness',
        modelName: 'Doll Likeness - by EDG\n',
        modelIntro: 'This is a model intro for latest version',
        createTime: '2023',
        modelType: 'LoRA',
        baseModel: 'SD 1.5',
        source: 'civitai',
        imageURLs: [
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/f12ca1d0-09db-4fbe-a6d2-9a514013b54f/width=450/01472-3511665204-((Masterpiece,%20best%20quality,edgQuality)),smug,smirk,_edgBulgr_woman,%20edgBulgr_face,edgBulgr_body,%20__lora_edgBulgarian_Doll_Liken.jpeg',
          'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/a0e80fc7-cacf-4555-93f2-30d0c4c367fe/width=450/01462-1149473501-((Masterpiece,%20best%20quality,edgQuality)),smug,smirk,_edgBulgr_woman,%20edgBulgr_face,edgBulgr_body,%20__lora_edgBulgarian_Doll_Liken.jpeg'
        ],
        civitaiURL: 'https://civitai.com/models/42903/doll-likeness-by-edg',
        trainingID: null
      }
    ]
  ]
])

const modelPresets: ModelPreset[] = [
  {
    presetUID: '1',
    imageURL:
      'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/f12ca1d0-09db-4fbe-a6d2-9a514013b54f/width=450/01472-3511665204-((Masterpiece,%20best%20quality,edgQuality)),smug,smirk,_edgBulgr_woman,%20edgBulgr_face,edgBulgr_body,%20__lora_edgBulgarian_Doll_Liken.jpeg',
    modelUID: '4',
    versionUID: 'Bulgarian Doll Likeness',
    params: new Map<string, string>()
  },
  {
    presetUID: '2',
    imageURL:
      'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/a0e80fc7-cacf-4555-93f2-30d0c4c367fe/width=450/01462-1149473501-((Masterpiece,%20best%20quality,edgQuality)),smug,smirk,_edgBulgr_woman,%20edgBulgr_face,edgBulgr_body,%20__lora_edgBulgarian_Doll_Liken.jpeg',
    modelUID: '4',
    versionUID: 'Bulgarian Doll Likeness',
    params: new Map<string, string>()
  },
  {
    presetUID: '3',
    imageURL:
      'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/f12ca1d0-09db-4fbe-a6d2-9a514013b54f/width=450/01472-3511665204-((Masterpiece,%20best%20quality,edgQuality)),smug,smirk,_edgBulgr_woman,%20edgBulgr_face,edgBulgr_body,%20__lora_edgBulgarian_Doll_Liken.jpeg',
    modelUID: '4',
    versionUID: 'Bulgarian Doll Likeness',
    params: new Map<string, string>()
  },
  {
    presetUID: '4',
    imageURL:
      'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/a0e80fc7-cacf-4555-93f2-30d0c4c367fe/width=450/01462-1149473501-((Masterpiece,%20best%20quality,edgQuality)),smug,smirk,_edgBulgr_woman,%20edgBulgr_face,edgBulgr_body,%20__lora_edgBulgarian_Doll_Liken.jpeg',
    modelUID: '4',
    versionUID: 'Bulgarian Doll Likeness',
    params: new Map<string, string>()
  }
]

class FakeModelDataLoader {
  getModelSnapshots(): ModelSnapshot[] {
    return [...modelSnapshots.values()].map((item) => item[0]).flatMap((item) => item)
  }
  getModelDetail(modelUID: string, versionUID: string | undefined): ModelDetail | null {
    const snapshots: ModelSnapshot[] | undefined = modelSnapshots.get(modelUID)
    if (snapshots == undefined) {
      throw new Error('modelUID does not exist')
    }
    let modelSnapshot: ModelSnapshot | null = null
    if (versionUID == '' || versionUID == undefined) {
      modelSnapshot = snapshots[0]
    } else {
      for (const s of snapshots) {
        if (s.versionUID == versionUID) {
          modelSnapshot = s
        }
      }
    }
    if (modelSnapshot == null) {
      throw new Error('versionUID does not exist: ' + versionUID)
    }
    return {
      modelSnapshot: modelSnapshot as ModelSnapshot,
      modelVersionUIDs: snapshots.map((s) => s.versionUID),
      modelPresets: modelPresets
    }
  }
}

export const ModelDataLoaderInst = new FakeModelDataLoader()
