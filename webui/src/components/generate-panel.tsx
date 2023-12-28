import { Button } from '@/components/ui/button'
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import { Textarea } from '@/components/ui/textarea'
import { zodResolver } from '@hookform/resolvers/zod'
import { useForm } from 'react-hook-form'
import * as z from 'zod'
import { Input } from './ui/input'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from './ui/select'
import { Slider } from './ui/slider'
import { TextSpan } from './text'
import { HWRatioEnum } from '@/gen_client'
import { cs, ps } from '@/store/project-store'
import { action } from 'mobx'
import { observer } from 'mobx-react-lite'

export const GeneratePanel = observer(() => {
  const generateFormSchema = z.object({
    prompt: z.string().min(2).max(50),
    negative_prompt: z.string(),
    h_w_ratio: z.string(),
    output_num: z.number().int().positive().lte(8),
    seeds: z.string(),
  })
  const form = useForm({
    resolver: zodResolver(generateFormSchema),
    defaultValues: {
      prompt: '',
      negative_prompt: '',
      h_w_ratio: '4:3',
      output_num: 4,
      seeds: '-1',
    },
  })

  const onSubmit = action((values: z.infer<typeof generateFormSchema>) => {
    // Create a new layer when:
    //   1. more than one layers are selected;
    //   2. or one layer is selected but is not created from generation.
    let outputLayerUUID: string | null = null
    if (cs.selectedIDs.length === 1 && ps.layers) {
      const found = Object.values(ps.layers).find(
        item => item.uuid === cs.selectedIDs[0]
      )
      if (found?.generations && found?.generations.length > 0) {
        outputLayerUUID = found.uuid
      }
    }
    ps.generate(outputLayerUUID, {
      prompt: values.prompt,
      negative_prompt: values.negative_prompt,
      h_w_ratio: values.h_w_ratio as HWRatioEnum,
      output_number: values.output_num,
      seeds: values.seeds.split(',').map(Number),
    })
  })

  return (
    <div className="w-full h-full mt-2 inline-flex flex-col">
      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-2">
          <FormField
            control={form.control}
            name="prompt"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">正向提示词</FormLabel>
                <FormControl>
                  <Textarea placeholder="正向提示词" {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="negative_prompt"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">反向提示词</FormLabel>
                <FormControl>
                  <Textarea placeholder="反向提示词" {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="h_w_ratio"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">比例</FormLabel>
                <Select
                  onValueChange={field.onChange}
                  defaultValue={field.value}
                >
                  <FormControl>
                    <SelectTrigger>
                      <SelectValue placeholder="比例" />
                    </SelectTrigger>
                  </FormControl>
                  <SelectContent>
                    <SelectItem value="1:1">1:1</SelectItem>
                    <SelectItem value="16:9">16:9</SelectItem>
                    <SelectItem value="4:3">4:3</SelectItem>
                  </SelectContent>
                </Select>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="output_num"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">张数</FormLabel>
                <FormControl>
                  <div className="flex flex-row">
                    <TextSpan
                      className="ml-3 mr-0 w-[10%]"
                      text={field.value.toString()}
                    />
                    <Slider
                      defaultValue={[4]}
                      max={8}
                      step={1}
                      onValueChange={val => field.onChange(val[0])}
                      className="w-[90%]"
                    />
                  </div>
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="seeds"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">种子</FormLabel>
                <FormControl>
                  <Input
                    type="string"
                    {...field}
                    onChange={event => field.onChange(+event.target.value)}
                    placeholder="种子"
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <div className="flex gap-2.5">
            <Button type="submit">生成</Button>
          </div>
        </form>
      </Form>
    </div>
  )
})
